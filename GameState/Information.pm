package GameState::Information;
use Moose;
use MooseX::ClassAttribute;
use MooseX::ABC;
use Log::Log4perl;
use namespace::autoclean;

my $logger = Log::Log4perl->get_logger('information');


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
has 'is_new' => (is => 'rw', isa => 'Bool', default => 1);

sub _matching {
	(my $self, my $other ) = @_;
	$logger->debug("Matching: " . $self . " " . $other);
	return $self->id == $other->id;
}
__PACKAGE__->meta->make_immutable;

1;
