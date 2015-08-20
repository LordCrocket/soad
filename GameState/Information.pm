package GameState::Information;
use Moose;
use MooseX::ClassAttribute;
use MooseX::ABC;
use namespace::autoclean;


use overload '~~' => "_matching", fallback => 1;

class_has 'counter' => (
      traits  => ['Counter'],
      is      => 'ro',
      isa     => 'Int',
      default => 0,
      handles => {
          inc_counter   => 'inc',
          dec_counter   => 'dec',
          reset_counter => 'reset',
      },
  );
has 'id' => (is => 'ro', isa => 'Int',required => '0',default => sub { return GameState::Information->inc_counter;});
has 'title' => (is => 'ro', isa => 'Str', required => '1');
has 'desc' => (is => 'ro', isa => 'Str', required => '0');

sub _matching {
	(my $one, my $two ) = @_;
	return $one->id == $two->id;
}
__PACKAGE__->meta->make_immutable;

1;
