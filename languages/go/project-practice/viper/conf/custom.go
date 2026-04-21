package conf

type Custom struct {
	WhiteList whiteList `mapstructure:"white_list" json:"white_list" yaml:"white_list"`
}

// 配置文件解析汇总
type whiteList struct {
	UserId      []string `mapstructure:"user_id" json:"user_id" yaml:"user_id"`
	RequestPath []string `mapstructure:"request_path" json:"request_path" yaml:"request_path"`
}
