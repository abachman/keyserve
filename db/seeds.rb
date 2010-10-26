puts "creating sample admin"
User.create(
  :email => "admin@slsdev.net",
  :password_hash => User::Password.create("password")
)

puts "creating sample keys"
{
  'adam@vostro410'   => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8jUYhBn0gYUl0H/lDut/rniubDzEZjB9cGcs1SjdFfmoZsKUmGcF1spqhdhBwRVqr8Z/tCHGycOtfrDUoEpRc0YIsFNRTL9koEIS21cJbpSO1ewjVfnxsPeoEB7fr1GQFX5u3BFusgL07zTaMSSOycmKntmt+odHsylJrdriLstHSqPIUYckoYUmqFbAVq9jjNEvWmGLTvecM1cyr6dHKgImtvA07Mc6XhjYaUmNuEXM5knVlnHaTrk9rZ+EGTjj81LF+LFQevxiZd6wD50DEbMmWvAGHVlCTsuL5sM4cWqINBW1Cq1kYbikaPFM5VCHYCc2YOdg3z7UnOyRHMk5+Q== adam@vostro410",
  'adam@watermelon'  => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsHv2f+PEMnRDBq9MSqAsbbCgzgTeNEe6ys7MVaksnIodfgZAWmrY9owpzmD57z1iEZF+kpQ/7m2bBijF3A92X8QJmnlts5Zde/S8ifgT+IyvkQYZC+X/BR/YhBKTun9oDUEXbV03eUpGagVw7FleNUjfHE93beULcpXcwrhEOU2QksySMnhDtRIPxSWsv0iR1SFZDHwwPYmfh4V8W8VkQTLN/SBmR0qEhqEG+2Fr9LvQDpHQGzohjyKmvQLiA8fvx4wN+yiR2JJQqkhIa6gu4UkgaHWzvn7hWynAB1vg093DaoTMxwKGpkuhlpPvrOTHJfKb3jrGKGovnrc9utfVow== adam@watermelon",
  'adam@vostro410.2' => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0VaKlIuWQu6/twvH0iHa55oZE+09TVuXgaVuyKxrlvREyVGYOJKsjkOiuz6rHehbK1vAbZRbyyt/6F0dzr3BY1RbHzK/kNWT4IUG9whDKMxQPAyq9nkOdqJn5QqTT+1rrzKxNa2hgShFaIcT1KjSH/janLbDev7ZRD1/gUIUFC/ERo+39TRJ6uG4Q/dpQosJeLR8f0zwueroyG4/Iw2KChnjC/rbkdiDmEPk6INve1y43R+ca8b6pfFJ680437uG6Y7N1c3mnkjo+r0YDWOIqtnGxoRj+kgMCtJXe4h7hYfjHn1sQ/T5N4cyn+BSF08bqYfMR8CoyAm5xZxOalzXSQ== adam@vostro410",
  'rsa-key-20100223' => "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAvrs7GPrO+ZG4r3HUhJEUOC/aufouIMG2IQBnbVW9HxuOtqlagHjQKPX+Bj51U0MbSHABNu4hkfB9Vsq6Btvzjdim7xXlg7lp4smBx2fnI4baMgpJOIcFDsXb4mK+RfJ+OyPpfZaxf3a2qQnPNFJbk0irmzOQ4gDqCavlAvRv61s= rsa-key-20100223"
}.each do |(name, key)|
  Key.create(:name => name,
             :contents => key)
end
