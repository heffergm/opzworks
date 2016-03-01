require 'inifile'
require 'rainbow'

module OpzWorks
  def self.config
    @config ||= Config.new
  end

  class Config
    attr_reader :ssh_user_name, :berks_repository_path, :aws_region, :aws_profile,
                :berks_base_path, :berks_s3_bucket, :berks_tarball_name, :berks_github_org

    def initialize
      file = ENV['AWS_CONFIG_FILE'] || "#{ENV['HOME']}/.aws/config"

      # abort unless required conditions are met
      abort "Config file #{file} not found, exiting!".foreground(:red) unless File.exist? file
      ini = IniFile.load(file)

      @opzworks_profile = ENV['OPZWORKS_PROFILE'] || 'opzworks'
      abort "Could not find [#{@opzworks_profile}] config block in #{file}, exiting!".foreground(:red) if ini[@opzworks_profile].empty?

      # set the region and the profile we want to pick up from ~/.aws/credentials
      @aws_profile = ENV['AWS_PROFILE'] || 'default'
      abort "Could not find [#{@aws_profile}] config block in #{file}, exiting!".foreground(:red) if ini[@aws_profile].empty?
      @aws_region  = ENV['AWS_REGION'] || ini[@aws_profile]['region']

      @ssh_user_name =
        ini[@opzworks_profile]['ssh-user-name'].strip unless ini[@opzworks_profile]['ssh-user-name'].nil?
      @berks_repository_path =
        ini[@opzworks_profile]['berks-repository-path'].strip unless ini[@opzworks_profile]['berks-repository-path'].nil?
      @berks_base_path =
        ini[@opzworks_profile]['berks-base-path'].strip unless ini[@opzworks_profile]['berks-base-path'].nil?
      @berks_s3_bucket =
        ini[@opzworks_profile]['berks-s3-bucket'].strip unless ini[@opzworks_profile]['berks-s3-bucket'].nil?
      @berks_tarball_name =
        ini[@opzworks_profile]['berks-tarball-name'].strip unless ini[@opzworks_profile]['berks-tarball-name'].nil?
      @berks_github_org =
        ini[@opzworks_profile]['berks-github-org'].strip unless ini[@opzworks_profile]['berks-github-org'].nil?
    end
  end
end
