require 'inifile'

module OVH
  CONFIG_PATH = %w(./ovh.conf ~/.ovh.conf /etc/ovh.conf)

  class ConfigurationManager
    def initialize
      @configs = CONFIG_PATH.map { |path| IniFile.load(path) }.compact
    end

    def get(section, name)
      # 1. Try env
      upname = name.upcase
      if ENV.key?(upname)
        return ENV[upname]
      end

      # 2. Try from config, by priority order
      @configs.each do
        |config|
        if config.has_section?(section)
          return config[section][name]
        end
      end

      return nil
    end
  end
end
