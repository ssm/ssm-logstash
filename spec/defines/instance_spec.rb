require 'spec_helper'

instance = 'test'

describe 'logstash::instance' do
  let(:title) { instance }
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "logstash class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_logstash__instance(instance) }
          it { is_expected.to contain_service("logstash@#{instance}").with_ensure('running') }
          it { is_expected.to contain_concat("logstash::instance::#{instance}") }
          it { is_expected.to contain_file("/etc/systemd/system/logstash@#{instance}.service") }
        end
      end
    end
  end
end
