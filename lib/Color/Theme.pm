package Color::Theme;

# DATE
# VERSION

1;
# ABSTRACT: Color theme structure

=head1 DESCRIPTION

This module specifies a structure for color themes. The distribution also comes
with utility routines and roles for managing color themes in applications.


=head1 SPECIFICATION

Color theme is a L<DefHash> containing these keys: C<v> (float, should be 1.1),
C<name> (str), C<summary> (str), C<no_color> (bool, should be set to 1 if this
is a color theme without any colors), and C<colors> (hash, the colors for items;
hash keys are item names and hash values are color values).

A color value should be a scalar containing a single color code which is
6-hexdigit RGB color (e.g. C<ffc0c0>), or a hashref containing multiple color
codes, or a coderef which should produce a color code (or a hash of color
codes).

Multiple color codes are used to support foreground/background values or ANSI
color codes that are not representable by RGB, among other things. The keys are:
C<fg> (RGB value for foreground), C<bg> (RGB value for background), C<ansi_fg>
(ANSI color escape code for foreground), C<ansi_bg> (ANSI color escape code for
background). Future keys like C<css> can be defined.

Allowing coderef as color allows for flexibility, e.g. for doing gradation
border color, random color, etc. See, for example,
L<Text::ANSITable::ColorTheme::Demo>. Code will be called with C<< ($self,
%args) >> where C<%args> contains various information, like C<name> (the item
name being requested), etc. In Text::ANSITable, you can get the row position
from C<< $self->{_draw}{y} >>.
