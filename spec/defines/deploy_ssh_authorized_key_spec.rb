require 'spec_helper'

describe "deploy::ssh_authorized_key" do
  let(:title) { 'user' }

  it do should contain_file("/home/user/.ssh").with(
    :ensure  => 'directory',
    :mode    => '0700',
    :owner   => 'user',
    :require => 'User[user]'
  ) end

  it do should contain_file("/home/user/.ssh/authorized_keys").with(
    :ensure  => 'present',
    :owner   => 'user',
    :group   => 'user',
    :mode    => '0600',
    :content => '',
    :require => "File[/home/user/.ssh]"
  ) end

  context "when $ssh_key" do
    context "is string" do
      let(:params) { { :ssh_key => "ssh key" } }
      it do should contain_file("/home/user/.ssh/authorized_keys").with(
        :content => "ssh key"
      ) end
    end
    context "is array" do
      let(:params) { { :ssh_key => %w{ssh key} } }
      it do should contain_file("/home/user/.ssh/authorized_keys").with(
        :content => "ssh\nkey"
      ) end
    end
  end
end