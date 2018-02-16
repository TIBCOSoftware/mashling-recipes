#!/usr/bin/expect
set timeout 120
spawn apt-get --yes --force-yes install slapd ldap-utils ldapscripts
expect "Administrator password: "
send -- "password\n"
expect "Confirm password: "
send -- "password\n"
expect eof
