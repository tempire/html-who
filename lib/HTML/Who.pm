package HTML::Who;
use Mojo::Base -base;

sub html {
  my $self = shift;

  return join '', map $self->examine(@$_) => @_;
}

# for one element
sub examine {
  my $self = shift;

  # Tag - base case
  return $self->enclosed_tag(@_) if $self->has_no_children(@_);

  # Decend into child
  my @children = @{+pop};
  return $self->open_tag(@_) . $self->examine(@children) . $self->close_tag(@_);
}

sub open_tag {
  my $self = shift;

  # tag name
  my $tag = '<' . shift;

  # attributes
  my $count = @_;
  for (my $i=0; $i<$count, @_, @_>1; $i=$i+2) {
    $tag .= sprintf(' %s="%s"', shift, shift);
  }

  # unpaired keys (<input type="checkbox" checked />)
  $tag .= ' ' . shift if @_;

  return $tag . '>';
}

sub close_tag {
  my $self = shift;

  return '</' . shift . '>';
}

sub text_node { return pop }

sub enclosed_tag {
  my $self = shift;

  # text node
  return $self->text_node(shift) if @_ == 1;

  my $tag = $self->open_tag(@_);
  $tag = substr $tag, 0, -1;
  $tag .= ' />';

  return $tag;
}

sub has_children {
  return 1 if ref pop eq 'ARRAY';
}

sub has_no_children {
  return !shift->has_children(pop);
}

1;
