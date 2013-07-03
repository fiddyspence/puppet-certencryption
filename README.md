Puppet::Util::Certencryption library to use SSL certs to encrypt/decrypt data

Library to do RSA based encryption for Puppet

There are 4 methods:

- encrypt(the rsa key, the file)
- decrypt(the rsa key, the file)
- encryptstring(the rsa key, the string)
- decryptstring(the rsa key, the string)

Also included are a parser function (decrypt()) and a fact demonstrating how to pass data around

Sample Puppet code
-----------

    class foo {
      $foovar = decrypt('/etc/foo/privatekey.pem',$::theencryptedfact_or_data')
      notify { $foovar: }
    }

Sample ruby code
-----------

    require 'puppet'
    require 'puppet/util/certencryption'
    a=Puppet::Util::Certencryption.new
    moo = a.encryptstring('/etc/puppetlabs/puppet/ssl/private_keys/puppet1.spence.org.uk.local.pem','moo')
    puts moo
    clear = a.decryptstring('/etc/puppetlabs/puppet/ssl/private_keys/puppet1.spence.org.uk.local.pem',moo)
    puts clear
