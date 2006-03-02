package Kwiki::Formatter::Textile;
use Spoon::Formatter -Base;
use Kwiki::Installer -base;

our $VERSION = do { q$Revision$ =~ /Revision: (\d+)/; sprintf "1.%03d", $1; };

const top_class => 'Kwiki::Formatter::Textile::Top';
const class_title => 'Textile Formatter';

package Kwiki::Formatter::Textile::Top;
use base 'Spoon::Formatter::Unit';

sub parse {
    $self->hub->css->add_file('formatter.css');
    return $self;
}

sub to_html {
    require Text::Textile;
    my $source = $self->text;
    my $result;
    my $parser = Kwiki::Formatter::Textile::HTML->new;
    $parser->kwiki_hub($self->hub);
    eval {
        $result = $parser->process($source);
    };
    return "<pre>\n$source\n$@\n</pre>\n"
      if $@ or not $result;
    $result =~ s/.*<body.*?>(.*)<\/body>.*/$1/s;
    return qq{<div class="formatter_textile">\n$result</div>};
}

package Kwiki::Formatter::Textile::HTML;
use base 'Text::Textile';
use base 'Kwiki::Base';
use Kwiki ':char_classes';

field 'kwiki_hub';

sub format_link {
    #my $self = shift;
    my (%args) = @_;
    my $text = exists $args{text} ? $args{text} : '';
    my $linktext = exists $args{linktext} ? $args{linktext} : '';
    my $title = $args{title};
    my $url = $args{url};
    my $clsty = $args{clsty};

    if (!defined $url || $url eq '') {
        return $text;
    }
    if (exists $self->{links} && exists $self->{links}{$url}) {
        $title ||= $self->{links}{$url}{title};
        $url = $self->{links}{$url}{url};
    }
    $linktext =~ s/ +$//;
    $linktext = $self->format_paragraph(text => $linktext);
    $url = $self->format_url(linktext => $linktext, url => $url);
    my $tag = qq{<a href="$url"};
    my $attr = $self->format_classstyle($clsty);
    $tag .= qq{ $attr} if $attr;
    if (defined $title) {
        $title =~ s/^\s+//;
        $tag .= qq{ title="$title"} if length($title);
    }
    $tag .= qq{>$linktext</a>};
    $tag;
}

package Kwiki::Formatter::Textile;
__DATA__

=head1 NAME 

Kwiki::Formatter::Textile - Textile formatter subclass for Kwiki

=head1 SYNOPSIS

In C<config.yaml>:

    formatter_class: Kwiki::Formatter::Textile

=head1 DESCRIPTION

Use Textile as your Kwiki formatting language.

=head1 AUTHOR

Jochen Lillich <jochen@lillich.info>

This module is based on C<Kwiki::Formatter::Pod> by Brian Ingerson <ingy@cpan.org>.

=head1 COPYRIGHT

Copyright (c) 2006. Jochen Lillich. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
__css/formatter.css__
/*
BODY, .logo { background: white; }

BODY {
  color: black;
  font-family: arial,sans-serif;
  margin: 0;
  padding: 1ex;
}
*/

div.formatter_pod TABLE {
  border-collapse: collapse;
  border-spacing: 0;
  border-width: 0;
  color: inherit;
}

div.formatter_pod IMG { border: 0; }
div.formatter_pod FORM { margin: 0; }
div.formatter_pod input { margin: 2px; }

div.formatter_pod .logo {
  float: left;
  width: 264px;
  height: 77px;
}

div.formatter_pod .front .logo  {
  float: none;
  display:block;
}

div.formatter_pod .front .searchbox  {
  margin: 2ex auto;
  text-align: center;
}

div.formatter_pod .front .menubar {
  text-align: center;
}

div.formatter_pod .menubar {
  background: #006699;
  margin: 1ex 0;
  padding: 1px;
} 

div.formatter_pod .menubar A {
  padding: 0.8ex;
  font: bold 10pt Arial,Helvetica,sans-serif;
}

div.formatter_pod .menubar A:link, .menubar A:visited {
  color: white;
  text-decoration: none;
}

div.formatter_pod .menubar A:hover {
  color: #ff6600;
  text-decoration: underline;
}

div.formatter_pod A:link, A:visited {
  background: transparent;
  color: #006699;
}

div.formatter_pod A[href="#POD_ERRORS"] {
  background: transparent;
  color: #FF0000;
}

div.formatter_pod TD {
  margin: 0;
  padding: 0;
}

div.formatter_pod DIV {
  border-width: 0;
}

div.formatter_pod DT {
  margin-top: 1em;
}

div.formatter_pod .credits TD {
  padding: 0.5ex 2ex;
}

div.formatter_pod .huge {
  font-size: 32pt;
}

div.formatter_pod .s {
  background: #dddddd;
  color: inherit;
}

div.formatter_pod .s TD, .r TD {
  padding: 0.2ex 1ex;
  vertical-align: baseline;
}

div.formatter_pod TH {
  background: #bbbbbb;
  color: inherit;
  padding: 0.4ex 1ex;
  text-align: left;
}

div.formatter_pod TH A:link, TH A:visited {
  background: transparent;
  color: black;
}

div.formatter_pod .box {
  border: 1px solid #006699;
  margin: 1ex 0;
  padding: 0;
}

div.formatter_pod .distfiles TD {
  padding: 0 2ex 0 0;
  vertical-align: baseline;
}

div.formatter_pod .manifest TD {
  padding: 0 1ex;
  vertical-align: top;
}

div.formatter_pod .l1 {
  font-weight: bold;
}

div.formatter_pod .l2 {
  font-weight: normal;
}

div.formatter_pod .t1, .t2, .t3, .t4  {
  background: #006699;
  color: white;
}
div.formatter_pod .t4 {
  padding: 0.2ex 0.4ex;
}
div.formatter_pod .t1, .t2, .t3  {
  padding: 0.5ex 1ex;
}

/* IE does not support  .box>.t1  Grrr */
div.formatter_pod .box .t1, .box .t2, .box .t3 {
  margin: 0;
}

div.formatter_pod .t1 {
  font-size: 1.4em;
  font-weight: bold;
  text-align: center;
}

div.formatter_pod .t2 {
  font-size: 1.0em;
  font-weight: bold;
  text-align: left;
}

div.formatter_pod .t3 {
  font-size: 1.0em;
  font-weight: normal;
  text-align: left;
}

/* width: 100%; border: 0.1px solid #FFFFFF; */ /* NN4 hack */

div.formatter_pod .datecell {
  text-align: center;
  width: 17em;
}

div.formatter_pod .cell {
  padding: 0.2ex 1ex;
  text-align: left;
}

div.formatter_pod .label {
  background: #aaaaaa;
  color: black;
  font-weight: bold;
  padding: 0.2ex 1ex;
  text-align: right;
  white-space: nowrap;
  vertical-align: baseline;
}

div.formatter_pod .categories {
  border-bottom: 3px double #006699;
  margin-bottom: 1ex;
  padding-bottom: 1ex;
}

div.formatter_pod .categories TABLE {
  margin: auto;
}

div.formatter_pod .categories TD {
  padding: 0.5ex 1ex;
  vertical-align: baseline;
}

div.formatter_pod .path A {
  background: transparent;
  color: #006699;
  font-weight: bold;
}

div.formatter_pod .pages {
  background: #dddddd;
  color: #006699;
  padding: 0.2ex 0.4ex;
}

div.formatter_pod .path {
  background: #dddddd;
  border-bottom: 1px solid #006699;
  color: #006699;
 /*  font-size: 1.4em;*/
  margin: 1ex 0;
  padding: 0.5ex 1ex;
}

div.formatter_pod .menubar TD {
  background: #006699;
  color: white;
}

div.formatter_pod .menubar {
  background: #006699;
  color: white;
  margin: 1ex 0;
  padding: 1px;
}

div.formatter_pod .menubar .links     {
  background: transparent;
  color: white;
  padding: 0.2ex;
  text-align: left;
}

div.formatter_pod .menubar .searchbar {
  background: black;
  color: black;
  margin: 0px;
  padding: 2px;
  text-align: right;
}

div.formatter_pod A.m:link, A.m:visited {
  background: #006699;
  color: white;
  font: bold 10pt Arial,Helvetica,sans-serif;
  text-decoration: none;
}

div.formatter_pod A.o:link, A.o:visited {
  background: #006699;
  color: #ccffcc;
  font: bold 10pt Arial,Helvetica,sans-serif;
  text-decoration: none;
}

div.formatter_pod A.o:hover {
  background: transparent;
  color: #ff6600;
  text-decoration: underline;
}

div.formatter_pod A.m:hover {
  background: transparent;
  color: #ff6600;
  text-decoration: underline;
}

div.formatter_pod table.dlsip     {
  background: #dddddd;
  border: 0.4ex solid #dddddd;
}

div.formatter_pod PRE     {
  background: #eeeeee;
  border: 1px solid #888888;
  color: black;
  padding: 1em;
  white-space: pre;
}

div.formatter_pod H1      {
  background: transparent;
  color: #006699;
  font-size: large;
}

div.formatter_pod H2      {
  background: transparent;
  color: #006699;
  font-size: medium;
}

div.formatter_pod IMG     {
  vertical-align: top;
}

div.formatter_pod .toc A  {
  text-decoration: none;
}

div.formatter_pod .toc LI {
  line-height: 1.2em;
  list-style-type: none;
}

div.formatter_pod .faq DT {
  font-size: 1.4em;
  font-weight: bold;
}

div.formatter_pod .chmenu {
  background: black;
  color: red;
  font: bold 1.1em Arial,Helvetica,sans-serif;
  margin: 1ex auto;
  padding: 0.5ex;
}

div.formatter_pod .chmenu TD {
  padding: 0.2ex 1ex;
}

div.formatter_pod .chmenu A:link, .chmenu A:visited  {
  background: transparent;
  color: white;
  text-decoration: none;
}

div.formatter_pod .chmenu A:hover {
  background: transparent;
  color: #ff6600;
  text-decoration: underline;
}

div.formatter_pod .column {
  padding: 0.5ex 1ex;
  vertical-align: top;
}

div.formatter_pod .datebar {
  margin: auto;
  width: 14em;
}

div.formatter_pod .date {
  background: transparent;
  color: #008000;
}


1;
__END__

=head1 NAME


=head1 ABSTRACT

C<Kwiki::Formatter::Textile> is a formatter plugin for the Kwiki wiki providing Textile notation.

=head1 SYNOPSIS

TODO

=head1 DESCRIPTION

TODO

=head1 AUTHOR

TODO

=head1 COPYRIGHT AND LICENSE

TODO

=cut
