# vagrant-fifo Vagrant plugin

vagrant-fifo is a Vagrant provider for [Project-Fifo](http://project-fifo.net/)

Note: this is under development and is probably broken. Patches welcome.

## Installation

### From Source

    git clone https://github.com/bakins/vagrant-fifo.git
    cd vagrant-fifo
    gem build vagrant-fifo.gemspec
    vagrant plugin install vagrant-fifo-<version>.gem
    cd example_box
    tar cvzf fifo.box ./metadata.json ./Vagrantfile
    vagrant box add fifo fifo.box --provider fifo

### From Rubygems

     vagrant plugin install vagrant-fifo

## Usage

Check out a chef-repo with a Fifo compatible Vagrantfile, then run "vagrant up"

    vagrant up --provider=fifo
    vagrant provision
    vagrant ssh
    vagrant destroy

Example Vagrantfile:

    Vagrant.configure("2") do |config|
      config.vm.box = "fifo"

      config.vm.provider :fifo do |fifo|
        fifo.dataset = "ubuntu-12.04"
        fifo.api_url = "http://192.168.1.100/api/v1/"
        fifo.username = "my-username"
        fifo.password = "my-password
        fifo.node_name = "node-name"
        fifo.ssh_username = "root"
        fifo.ssh_private_key_path = "/path/to/my/private/key"
      end
    end

You can also use a box url, rather than building the example box on
your local machine:

    Vagrant.configure("2") do |config|
       config.vm.box = "fifo"
       config.vm.box_url = "http://www.akins.org/vagrant/fifo.box"
       ...
    end

Feel free to mirror your own copy of `fifo.box`

#### Configuration

The following options are availible. These are used like:

    config.vm.provider :fifo do |fifo|
        fifo.dataset = "ubuntu-12.04"
	...
    end

* dataset - "OS Image" to use. Can be name or ID
* api_url - api endpoint for project-fifo installation
* username - api username
* password - api password
* node_name - the project-fifo node\name/alias for this vm- not this
  is not the hostname
* ssh_username - username to use for ssh
* ssh\_private\_key - ssh private key to use for ssh. This should be
  the private key for the public key you registered in project-fifo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

Based on [vagrant-joyent](https://github.com/someara/vagrant-joyent)

## License
Apache 2
