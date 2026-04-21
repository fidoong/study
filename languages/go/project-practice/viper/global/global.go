package global

import (
	"viper_demo/conf"

	"github.com/spf13/viper"
)

type Application struct {
	ConfViper *viper.Viper
	Conf      conf.Config
	Custom    conf.Custom
}

var App = new(Application)
