require 'spec_helper'

instance_name = 'test01'
config_name   = 'input01'

describe 'logstash::config' do
  let(:title) { config_name }
  let(:params) do
    { instance: instance_name }
  end
  let(:pre_condition) do
    [ 'logstash::instance{ "%s": }' % [instance_name] ]
  end
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "without parameters" do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_logstash__config(config_name).with_instance(instance_name) }
          it { is_expected.to contain_concat__fragment('logstash::config::%s::%s' % [instance_name, config_name]) }
        end

        context "ensure => absent" do
          let(:params) do
            {
              instance: instance_name,
              ensure: 'absent'
            }
          end
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_logstash__config(config_name).with_instance(instance_name).with_ensure('absent') }
          it { is_expected.to contain_concat__fragment('logstash::config::%s::%s' % [instance_name, config_name]).with_ensure('absent') }
        end
      end
    end
  end
end
