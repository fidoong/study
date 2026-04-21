package bootstrap

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"viper_demo/global"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
)

// getProjectRoot 获取项目根目录
func getProjectRoot() string {
	_, filename, _, _ := runtime.Caller(0)
	bootstrapDir := filepath.Dir(filename)
	return filepath.Join(bootstrapDir, "..")
}

// getEnv 获取环境变量，若未设置则返回默认值
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// setupViperEnv 配置 viper 的环境变量支持（12-Factor App 风格）
//
// 规则：
//   - 环境变量前缀为 APP_，例如 APP_PORT 会映射到 port
//   - 嵌套配置用 _ 分隔，例如 APP_MYSQL_HOST 映射到 mysql.host
//   - 环境变量优先级高于配置文件
func setupViperEnv(v *viper.Viper) {
	// 设置环境变量前缀
	v.SetEnvPrefix("APP")

	// 自动读取所有环境变量
	v.AutomaticEnv()

	// 替换器：把配置 key 中的 . 替换成 _ 来匹配环境变量
	// 例如配置项 mysql.host 对应环境变量 APP_MYSQL_HOST
	v.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

	// 显式绑定关键配置项（用于文档化和 IDE 提示）
	v.BindEnv("app.env", "APP_ENV")
	v.BindEnv("app.port", "APP_PORT")
	v.BindEnv("app.app_name", "APP_NAME")
	v.BindEnv("app.app_url", "APP_URL")
	v.BindEnv("mysql.host", "MYSQL_HOST")
	v.BindEnv("mysql.port", "MYSQL_PORT")
	v.BindEnv("mysql.user", "MYSQL_USER")
	v.BindEnv("mysql.password", "<PASSWORD>")
	v.BindEnv("mysql.db_name", "MYSQL_DB")
}

// expandEnvInFile 读取文件内容，替换 ${VAR} 或 $VAR 形式的环境变量占位符
func expandEnvInFile(path string) ([]byte, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	// os.ExpandEnv 会把 ${VAR} 和 $VAR 替换成对应环境变量值
	expanded := os.ExpandEnv(string(data))
	return []byte(expanded), nil
}

// configAssemble 组装配置，支持配置文件 + 环境变量覆盖（12-Factor 风格）
func configAssemble[T any](v *viper.Viper, configPath string, viperStruct T) *viper.Viper {
	// 先启用环境变量支持
	setupViperEnv(v)

	// 读取配置文件（先占位，后面可能被环境变量覆盖）
	if _, err := os.Stat(configPath); err == nil {
		// 方式一：直接读取（配置文件里写死值）
		// v.SetConfigFile(configPath)
		// v.SetConfigType("yaml")
		// v.ReadInConfig()

		// 方式二：先替换 ${XXX} 占位符，再让 viper 读取（推荐）
		expandedData, err := expandEnvInFile(configPath)
		if err != nil {
			panic(fmt.Errorf("read config file failed: %s", err))
		}
		v.SetConfigType("yaml")
		if err := v.ReadConfig(strings.NewReader(string(expandedData))); err != nil {
			panic(fmt.Errorf("parse config failed: %s", err))
		}
	}

	// 监听配置文件变更（仅本地开发有用）
	v.WatchConfig()
	v.OnConfigChange(func(in fsnotify.Event) {
		fmt.Printf("[Config] file changed: %s\n", in.Name)
		if err := v.Unmarshal(viperStruct); err != nil {
			fmt.Printf("[Config] reload failed: %s\n", err)
		} else {
			fmt.Printf("[Config] reloaded successfully\n")
		}
	})

	// 反序列化到结构体
	if err := v.Unmarshal(viperStruct); err != nil {
		panic(fmt.Errorf("unmarshal config failed: %s", err))
	}

	return v
}

// printConfig 打印生效的配置（脱敏处理）
func printConfig(cfg global.Application) {
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("📋 Effective Configuration (12-Factor Style)")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Printf("  Environment : %s\n", cfg.Conf.App.Env)
	fmt.Printf("  App Name    : %s\n", cfg.Conf.App.AppName)
	fmt.Printf("  App URL     : %s\n", cfg.Conf.App.AppUrl)
	fmt.Printf("  Port        : %d\n", cfg.Conf.App.Port)
	fmt.Printf("  MySQL Host  : %s\n", cfg.Conf.MySQL.Host)
	fmt.Printf("  MySQL Port  : %d\n", cfg.Conf.MySQL.Port)
	fmt.Printf("  MySQL User  : %s\n", cfg.Conf.MySQL.User)
	fmt.Printf("  MySQL DB    : %s\n", cfg.Conf.MySQL.DBName)
	// 密码脱敏，不打印
	if cfg.Conf.MySQL.Password != "" {
		fmt.Printf("  MySQL Pass  : %s\n", strings.Repeat("*", len(cfg.Conf.MySQL.Password)))
	} else {
		fmt.Printf("  MySQL Pass  : (empty)\n")
	}
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
}

// InitializeConfig 初始化配置（12-Factor App 风格）
//
// 配置加载优先级（从高到低）：
//  1. 环境变量（如 APP_PORT=9090）
//  2. 配置文件中的 ${VAR} 占位符替换
//  3. 配置文件中的硬编码默认值
//
// 使用示例：
//
//	APP_ENV=prod APP_PORT=443 MYSQL_PASSWORD=<PASSWORD> go run ./viper
func InitializeConfig() {
	env := getEnv("APP_ENV", "local")
	root := getProjectRoot()

	fmt.Printf("[Config] Environment: %s\n", env)

	// 初始化全局配置 viper 实例
	global.App.ConfViper = viper.New()

	// 加载主配置文件
	configPath := filepath.Join(root, "conf/files", env, "config.yaml")
	fmt.Printf("[Config] Loading: %s\n", configPath)

	configAssemble(global.App.ConfViper, configPath, &global.App.Conf)

	// 加载自定义配置（可选，复用同一个 viper 实例或新建）
	customPath := filepath.Join(root, "conf/files", env, "custom.yaml")
	if _, err := os.Stat(customPath); err == nil {
		fmt.Printf("[Config] Loading: %s\n", customPath)
		customViper := viper.New()
		configAssemble(customViper, customPath, &global.App.Custom)
	}

	// 打印最终生效的配置
	printConfig(*global.App)
}
