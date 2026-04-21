package conf

type Config struct {
	App   AppConfig   `mapstructure:"app"`
	MySQL MySQLConfig `mapstructure:"MySQL"`
}
type AppConfig struct {
	Env     string `mapstructure:"env"`
	Port    int    `mapstructure:"port"`
	AppName string `mapstructure:"app_name"`
	AppUrl  string `mapstructure:"app_url"`
}
type MySQLConfig struct {
	Host     string `mapstructure:"host"`
	Port     int    `mapstructure:"port"`
	User     string `mapstructure:"user"`
	Password string `mapstructure:"password"`
	DBName   string `mapstructure:"db_name"`
}
