package GameModule;
use Moose;
use MooseX::ClassAttribute;
use MooseX::ABC;
use namespace::autoclean;

sub setup {} 
sub update_game_state {} 



__PACKAGE__->meta->make_immutable;

1;
