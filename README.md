# vagrant-fifo Vagrant plugin

vagrant-fifo is a Vagrant provider for the Fifo Cloud and SmartDatacenter

## Installation

    $ git clone https://github.com/someara/vagrant-fifo/
    $ cd vagrant-fifo
    $ gem build vagrant-fifo.gemspec ; 
    $ vagrant plugin install vagrant-fifo-0.2.1.gem 
    $ vagrant box add dummy ./dummy.box

## Usage

Check out a chef-repo with a Fifo compatible Vagrantfile, then run "vagrant up"

    $ git clone https://github.com/someara/vagrant-fifo-hello_world-repo 
    $ cd vagrant-fifo-hello_world-repo
    $ vagrant up --provider=fifo
    $ vagrant provision
    $ vagrant ssh
    $ vagrant destroy

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
