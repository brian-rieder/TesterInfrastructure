#!/bin/bash

# Generate temporary directory, zip file, and user file names with randomized tags
TMPD=$(mktemp -d /tmp/tester.$USER.XXXXX)
TMPZ=$(mktemp $TMPD/testfile.$USER.XXXXX.zip)
TMPU=$(mktemp userinfo.$USER.XXXXX.txt)

# Remove all temporary files upon ANY kind of exit (C-c, etc.)
trap cleanup EXIT
cleanup()
{
    echo "Removing $TMPD"
    rm "$TMPU"
    rm -rf "$TMPD"
}

# Private key to match ece264z6's public key
write_key()
{
cat <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA0iFu3WckPWj1vvPqqlNCUYDB1wJ5e2Yu8W9drb8qPitg1jZC
M9BywflT6tXjCHGSQ8sxe5D5rSH4C9vGc/yGfIWkXXGKLTmG9vEYbLFlyWYhTOh0
/w5LafqQTAyAvw4q7apwqg6U0RCY3NeoBB+Oo3s/+Me/ULkjw+Gzx9doSlLn6W50
UoCFwghhzFjZz8/IWA531rqO9hAySHT8qW37b28FB/D7CzHtfIOFY0I9TtwMCGaI
26rwd9D2Wrf9Ko1RvWzTYrJYOKyGhwrgDNR933INot44LyotOX7fLdTBGYKinhMm
etFeQFb09ir7MYg5X/4rDr+YIfPMHN6o/TLwbwIBIwKCAQAwB6RP3Q+ZAgxI50uU
pVD8r7dHFoIq1YcSnRy5/88kJywTtKFq7dEWZN/7KZL6nZ3GWlR0A+FMJQV/Dam0
HHaC3Lfa2B+VTvpHEok9amBojF9iCT9QPcgYOUWNubcHGS5iNZYYPdjfVEAyem+L
6fS3pySQoq9i6H00FlT6emD7CzhUIruL8vRgkiXe6fe4sZh0SG9AQ6AUsj8kEXTH
k8ATPrg94wMajeaD2s1zYGqV9VFCxxiY3utuBvdBKo07SsgNQPO8m3EQGEaReWem
7Qt/k4au9atlxGcsvam8aKdPCz8AtKLbI4wZe86pG3euAz5mMKGoDKdUS+d0B85f
wReLAoGBAPwNVLlgspcUEQ1KthhDOmH+d+BcI2LySNwPZtl8Mk6x/CGLJf7cWZi+
9PgNuytTtctGk1kUzlszCINAQKJJWsFIijy8CrQkb5l8rSxftwajQAFRvursdbZK
1VNQO2KKMznWRvvq3DUcGxW86RLU5Vt++5QNrZkKACBbqY91tRDvAoGBANVsAcZt
hwGHd+7SYyXEjGtc2bDBb0+pO4H7QcREFURpQH1uCc6aq4Q8sUp8wT+rFP09rCQq
DU9DafldXTD9y2U65mxNf5Vt0rhN6o4y0GTuDJ8TrH9leTOK68VFT4KVfjUkteIR
OaQ0vjcVabzDVKzh7dPB2qMHJ5clkvKkkRiBAoGAHM5S01uCH+UJQ1j+3jORpMyf
/GJNL+Es5fMhsnSYCP5l9TR5XvSchnw5QOugXLkcFztECi5DeCMW6m2+Pm7Iix47
rytu8AQqAumtZCgyLKTxXzyK2QUUxGBS5PM5/KIUe6N106XQBhHXNa8wlHAaNlen
uSYid+Piwd6XCRTEPHMCgYEAyTnzC4vXEBIDXYSJXh+3mG18yzoJ3WUMOLmzCYIF
bGM8zgiqKTK++QYGPuqnk80xDAbywwMT3QUMJaEr+v3rqJaeveKrfkL54PkBuUXa
bcqA7cIXq1EL4CPlnL2xXd1oXf4Kk1IRxrVi43qW5S0ylF/9foOToQa+7Zh0m6J6
LQsCgYEAlsrkW5JzkwhI0AcI1OSc7kiOewLKGTtb9bW2cCWCTO1ecmV+j8FlQgXP
YxXh5qnTlpIb4jG34UqRSh6oTgPa/K8vvg8ZkkCPqlpsh0qrDTRgpbXgjrhT9AqH
MY/qMcswHOksDtO3sFEggmpOrRrWntGu62op0wlPBUv2lzSFBXc=
-----END RSA PRIVATE KEY-----
EOF
}

# Write the user info file --> name and date/time
echo $USER > $TMPU
date >> $TMPU

# Write the SSH private key to the temporary directory
write_key > $TMPD/auth_key
chmod 600 $TMPD/auth_key

# Zip it all away to magical SSH land for testing
zip - $1 $TMPU | ssh -T ece264z6@ecegrid.ecn.purdue.edu -i $TMPD/auth_key "cat - > $TMPZ" #test.zip"


# Manifesting
# -- Each tester is unique (wants to know what files to zip, what server side tester to run)
# -- Going to need a configuration file for script (can keep separate)
# -- Need to find out how to compile it into script (ideally)

# Not on ECN computers, want the whole thing to SSH onto their ecn account
# -- prompt for username
# -- ssh in, print out SSH passwordless login
