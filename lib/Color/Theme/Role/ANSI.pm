package Color::Theme::Role::ANSI;

# DATE
# VERSION

use 5.010001;
use Moo::Role;

use Color::ANSI::Util qw(ansi24bfg ansi24bbg);
with 'Color::Theme::Role';
with 'Term::App::Role::Attrs';

sub theme_color_to_ansi {
    my ($self, $c, $args, $is_bg) = @_;

    # empty? skip
    return '' if !defined($c) || !length($c);

    my $coldepth = $self->color_depth;

    if ($coldepth >= 2**24) {
        if (ref $c) {
            my $ansifg = $c->{ansi_fg};
            $ansifg //= ansi24bfg($c->{fg}) if defined $c->{fg};
            $ansifg //= "";
            my $ansibg = $c->{ansi_bg};
            $ansibg //= ansi24bbg($c->{bg}) if defined $c->{bg};
            $ansibg //= "";
            $c = $ansifg . $ansibg;
        } else {
            $c = $is_bg ? ansi24bbg($c) : ansi24bfg($c);
        }
    } elsif ($coldepth >= 256) {
        if (ref $c) {
            my $ansifg = $c->{ansi_fg};
            $ansifg //= ansi256fg($c->{fg}) if defined $c->{fg};
            $ansifg //= "";
            my $ansibg = $c->{ansi_bg};
            $ansibg //= ansi256bg($c->{bg}) if defined $c->{bg};
            $ansibg //= "";
            $c = $ansifg . $ansibg;
        } else {
            $c = $is_bg ? ansi256bg($c) : ansi256fg($c);
        }
    } else {
        if (ref $c) {
            my $ansifg = $c->{ansi_fg};
            $ansifg //= ansi16fg($c->{fg}) if defined $c->{fg};
            $ansifg //= "";
            my $ansibg = $c->{ansi_bg};
            $ansibg //= ansi16bg($c->{bg}) if defined $c->{bg};
            $ansibg //= "";
            $c = $ansifg . $ansibg;
        } else {
            $c = $is_bg ? ansi16bg($c) : ansi16fg($c);
        }
    }
    $c;
}

sub get_theme_color_as_ansi {
    my ($self, $item_name, $args) = @_;
    my $c = $self->get_theme_color($item_name) // '';
    $self->_themecol2ansi(
        $c, {name=>$item_name, %{ $args // {} }},
        $item_name =~ /_bg$/);
}

1;
# ABSTRACT: Role for class wanting to support color themes (ANSI support)

=head1 DESCRIPTION

This role consumes L<Color::Theme::Role> and L<Term::App::Role::Attrs>.


=head1 METHODS


=head2 $cl->theme_color_to_ansi($color) => str

=head2 $cl->get_theme_color_as_ansi($item_name, \%args) => str

Like C<get_theme_color>, but if the resulting color value is a coderef, will
call that coderef, passing C<%args> to it and returning the value. Also, will
convert color theme to ANSI color escape codes.

When converting to ANSI code, will consult C<color_depth> from
L<Term::App::Role::Attr>.

