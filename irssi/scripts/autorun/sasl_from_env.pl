use strict;
use warnings;
use Irssi;

# Inject the Libera SASL password from the environment so the secret never
# lives in the tracked irssi config. Set this in ~/.config/secrets (sourced by
# .zshrc, not committed):
#
#   export LIBERA_SASL_PASSWORD="..."
#
# With `settings_autosave = no` in config, irssi won't persist this to
# ~/.irssi/config. Avoid running `/save` while authenticated — it would write
# the password into the (git-tracked) config file.

my $pass = $ENV{'LIBERA_SASL_PASSWORD'};

if (defined $pass && length $pass) {
    # The leading '^' suppresses command echo so the password isn't printed.
    Irssi::command("^sasl set Libera b101 $pass PLAIN");
    Irssi::print('sasl_from_env: SASL PLAIN configured for Libera (b101)');
} else {
    Irssi::print('sasl_from_env: LIBERA_SASL_PASSWORD unset — connecting without SASL');
}
