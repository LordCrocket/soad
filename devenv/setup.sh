sudo apt-get install -qy libmoose-perl libmoosex-classattribute-perl libmoosex-strictconstructor-perl liblog-log4perl-perl


su vagrant <<'EOF'
curl -sL https://cpanmin.us | perl - App::cpanminus
export PATH=/home/vagrant/perl5/bin/:$PATH
cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
echo 'eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`' >> /home/vagrant/.profile
cpanm -q MooseX::ABC String::Trim Readonly List::Compare.pm Clone Test::Exception Array/Utils.pm String/Numeric.pm
git clone https://github.com/LordCrocket/soad.git
(cd soad/ ; perl t/GameState.t ; perl t/GenerateCitizen.t)
EOF


