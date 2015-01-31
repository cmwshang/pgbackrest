####################################################################################################################################
# CONFIG MODULE
####################################################################################################################################
package BackRest::Config;

use threads;
use strict;
use warnings;
use Carp;
use Pod::Usage;

use File::Basename;
use Getopt::Long;

use lib dirname($0) . '/../lib';
use BackRest::Exception;
use BackRest::Utility;

use Exporter qw(import);

our @EXPORT = qw(config_load config_key_load config_section_load operation_get operation_set param_get

                 FILE_MANIFEST FILE_VERSION FILE_POSTMASTER_PID FILE_RECOVERY_CONF
                 PATH_LATEST

                 OP_ARCHIVE_GET OP_ARCHIVE_PUSH OP_BACKUP OP_RESTORE OP_EXPIRE

                 BACKUP_TYPE_FULL BACKUP_TYPE_DIFF BACKUP_TYPE_INCR

                 RECOVERY_TYPE_NAME RECOVERY_TYPE_TIME RECOVERY_TYPE_XID RECOVERY_TYPE_PRESERVE RECOVERY_TYPE_NONE
                 RECOVERY_TYPE_DEFAULT

                 PARAM_CONFIG PARAM_STANZA PARAM_TYPE PARAM_DELTA PARAM_SET PARAM_NO_START_STOP PARAM_FORCE PARAM_TARGET
                 PARAM_TARGET_EXCLUSIVE PARAM_TARGET_RESUME PARAM_TARGET_TIMELINE CONFIG_SECTION_RECOVERY

                 PARAM_VERSION PARAM_HELP PARAM_TEST PARAM_TEST_DELAY PARAM_TEST_NO_FORK

                 CONFIG_SECTION_COMMAND CONFIG_SECTION_COMMAND_OPTION CONFIG_SECTION_LOG CONFIG_SECTION_BACKUP
                 CONFIG_SECTION_RESTORE CONFIG_SECTION_RECOVERY CONFIG_SECTION_RECOVERY_OPTION CONFIG_SECTION_TABLESPACE_MAP
                 CONFIG_SECTION_ARCHIVE CONFIG_SECTION_RETENTION CONFIG_SECTION_STANZA

                 CONFIG_KEY_USER CONFIG_KEY_HOST CONFIG_KEY_PATH

                 CONFIG_KEY_THREAD_MAX CONFIG_KEY_THREAD_TIMEOUT CONFIG_KEY_HARDLINK CONFIG_KEY_ARCHIVE_REQUIRED
                 CONFIG_KEY_ARCHIVE_MAX_MB CONFIG_KEY_START_FAST CONFIG_KEY_COMPRESS_ASYNC

                 CONFIG_KEY_LEVEL_FILE CONFIG_KEY_LEVEL_CONSOLE

                 CONFIG_KEY_COMPRESS CONFIG_KEY_CHECKSUM CONFIG_KEY_PSQL CONFIG_KEY_REMOTE

                 CONFIG_KEY_FULL_RETENTION CONFIG_KEY_DIFFERENTIAL_RETENTION CONFIG_KEY_ARCHIVE_RETENTION_TYPE
                 CONFIG_KEY_ARCHIVE_RETENTION

                 CONFIG_KEY_STANDBY_MODE CONFIG_KEY_PRIMARY_CONNINFO CONFIG_KEY_TRIGGER_FILE CONFIG_KEY_RESTORE_COMMAND
                 CONFIG_KEY_ARCHIVE_CLEANUP_COMMAND CONFIG_KEY_RECOVERY_END_COMMAND);

####################################################################################################################################
# File/path constants
####################################################################################################################################
use constant
{
    FILE_MANIFEST       => 'backup.manifest',
    FILE_VERSION        => 'version',
    FILE_POSTMASTER_PID => 'postmaster.pid',
    FILE_RECOVERY_CONF  => 'recovery.conf',

    PATH_LATEST         => 'latest'
};

####################################################################################################################################
# Operation constants - basic operations that are allowed in backrest
####################################################################################################################################
use constant
{
    OP_ARCHIVE_GET   => 'archive-get',
    OP_ARCHIVE_PUSH  => 'archive-push',
    OP_BACKUP        => 'backup',
    OP_RESTORE       => 'restore',
    OP_EXPIRE        => 'expire'
};

####################################################################################################################################
# BACKUP Type Constants
####################################################################################################################################
use constant
{
    BACKUP_TYPE_FULL          => 'full',
    BACKUP_TYPE_DIFF          => 'diff',
    BACKUP_TYPE_INCR          => 'incr'
};

####################################################################################################################################
# RECOVERY Type Constants
####################################################################################################################################
use constant
{
    RECOVERY_TYPE_NAME          => 'name',
    RECOVERY_TYPE_TIME          => 'time',
    RECOVERY_TYPE_XID           => 'xid',
    RECOVERY_TYPE_PRESERVE      => 'preserve',
    RECOVERY_TYPE_NONE          => 'none',
    RECOVERY_TYPE_DEFAULT       => 'default'
};

####################################################################################################################################
# Parameter constants
####################################################################################################################################
use constant
{
    PARAM_CONFIG            => 'config',
    PARAM_STANZA            => 'stanza',
    PARAM_TYPE              => 'type',
    PARAM_NO_START_STOP     => 'no-start-stop',
    PARAM_DELTA             => 'delta',
    PARAM_SET               => 'set',
    PARAM_FORCE             => 'force',
    PARAM_VERSION           => 'version',
    PARAM_HELP              => 'help',

    PARAM_TARGET            => 'target',
    PARAM_TARGET_EXCLUSIVE  => 'target-exclusive',
    PARAM_TARGET_RESUME     => 'target-resume',
    PARAM_TARGET_TIMELINE   => 'target-timeline',

    PARAM_TEST              => 'test',
    PARAM_TEST_DELAY        => 'test-delay',
    PARAM_TEST_NO_FORK      => 'no-fork'
};

####################################################################################################################################
# Configuration constants
####################################################################################################################################
use constant
{
    CONFIG_SECTION_COMMAND             => 'command',
    CONFIG_SECTION_COMMAND_OPTION      => 'command:option',
    CONFIG_SECTION_LOG                 => 'log',
    CONFIG_SECTION_BACKUP              => 'backup',
    CONFIG_SECTION_RESTORE             => 'restore',
    CONFIG_SECTION_RECOVERY            => 'recovery',
    CONFIG_SECTION_RECOVERY_OPTION     => 'recovery:option',
    CONFIG_SECTION_TABLESPACE_MAP      => 'tablespace:map',
    CONFIG_SECTION_ARCHIVE             => 'archive',
    CONFIG_SECTION_RETENTION           => 'retention',
    CONFIG_SECTION_STANZA              => 'stanza',

    CONFIG_KEY_USER                    => 'user',
    CONFIG_KEY_HOST                    => 'host',
    CONFIG_KEY_PATH                    => 'path',

    CONFIG_KEY_THREAD_MAX              => 'thread-max',
    CONFIG_KEY_THREAD_TIMEOUT          => 'thread-timeout',
    CONFIG_KEY_HARDLINK                => 'hardlink',
    CONFIG_KEY_ARCHIVE_REQUIRED        => 'archive-required',
    CONFIG_KEY_ARCHIVE_MAX_MB          => 'archive-max-mb',
    CONFIG_KEY_START_FAST              => 'start-fast',
    CONFIG_KEY_COMPRESS_ASYNC          => 'compress-async',

    CONFIG_KEY_LEVEL_FILE              => 'level-file',
    CONFIG_KEY_LEVEL_CONSOLE           => 'level-console',

    CONFIG_KEY_COMPRESS                => 'compress',
    CONFIG_KEY_CHECKSUM                => 'checksum',
    CONFIG_KEY_PSQL                    => 'psql',
    CONFIG_KEY_REMOTE                  => 'remote',

    CONFIG_KEY_FULL_RETENTION          => 'full-retention',
    CONFIG_KEY_DIFFERENTIAL_RETENTION  => 'differential-retention',
    CONFIG_KEY_ARCHIVE_RETENTION_TYPE  => 'archive-retention-type',
    CONFIG_KEY_ARCHIVE_RETENTION       => 'archive-retention',

    CONFIG_KEY_STANDBY_MODE            => 'standby-mode',
    CONFIG_KEY_PRIMARY_CONNINFO        => 'primary-conninfo',
    CONFIG_KEY_TRIGGER_FILE            => 'trigger-file',
    CONFIG_KEY_RESTORE_COMMAND         => 'restore-command',
    CONFIG_KEY_ARCHIVE_CLEANUP_COMMAND => 'archive-cleanup-command',
    CONFIG_KEY_RECOVERY_END_COMMAND    => 'recovery-end-command'
};

####################################################################################################################################
# Global variables
####################################################################################################################################
my %oConfig;            # Configuration hash
my %oParam = ();        # Parameter hash
my $strOperation;       # Operation (backup, archive-get, ...)

####################################################################################################################################
# CONFIG_LOAD
#
# Load config file.
####################################################################################################################################
sub config_load
{
    my $strFile = shift;    # Full path to ini file to load from

    # Default for general parameters
    param_set(PARAM_NO_START_STOP, false); # Do not perform start/stop backup (and archive-required gets set to false)
    param_set(PARAM_FORCE, false);         # Force an action that would not normally be allowed (varies by action)
    param_set(PARAM_VERSION, false);       # Display version and exit
    param_set(PARAM_HELP, false);          # Display help and exit

    # Defaults for test parameters - not for general use
    param_set(PARAM_TEST_NO_FORK, false);  # Prevents the archive process from forking when local archiving is enabled
    param_set(PARAM_TEST, false);          # Enters test mode - not harmful, but adds special logging and pauses for unit testing
    param_set(PARAM_TEST_DELAY, 5);        # Seconds to delay after a test point (default is not enough for manual tests)

    # Get command line parameters
    GetOptions (\%oParam, PARAM_CONFIG . '=s', PARAM_STANZA . '=s', PARAM_TYPE . '=s', PARAM_DELTA, PARAM_SET . '=s',
                          PARAM_NO_START_STOP, PARAM_FORCE, PARAM_TARGET . '=s', PARAM_TARGET_EXCLUSIVE, PARAM_TARGET_RESUME,
                          PARAM_TARGET_TIMELINE . '=s', PARAM_VERSION, PARAM_HELP,
                          PARAM_TEST, PARAM_TEST_DELAY . '=s', PARAM_TEST_NO_FORK)
        or pod2usage(2);

    # Display version and exit if requested
    if (param_get(PARAM_VERSION) || param_get(PARAM_HELP))
    {
        print 'pg_backrest ' . version_get() . "\n";

        if (!param_get(PARAM_HELP))
        {
            exit 0;
        }
    }

    # Display help and exit if requested
    if (param_get(PARAM_HELP))
    {
        print "\n";
        pod2usage();
    }

    # Get and validate the operation
    $strOperation = $ARGV[0];

    # Validate params
    param_valid();

    # # Validate thread parameter
    # if (defined(param_get(PARAM_THREAD)) && !(param_get(PARAM_THREAD) >= 1))
    # {
    #     confess &log(ERROR, 'thread parameter should be >= 1');
    # }

    # Get configuration parameter and load it
    if (!defined(param_get(PARAM_CONFIG)))
    {
        param_set(PARAM_CONFIG, '/etc/pg_backrest.conf');
    }

    ini_load(param_get(PARAM_CONFIG), \%oConfig);

    # If this is a restore, then try to default config
    if (!defined(config_key_load(CONFIG_SECTION_RESTORE, CONFIG_KEY_PATH)))
    {
        if (!defined(config_key_load(CONFIG_SECTION_BACKUP, CONFIG_KEY_HOST)))
        {
            $oConfig{'global:restore'}{path} = config_key_load(CONFIG_SECTION_BACKUP, CONFIG_KEY_PATH);
        }

        if (!defined(config_key_load(CONFIG_SECTION_RESTORE, CONFIG_KEY_PATH)))
        {
            $oConfig{'global:restore'}{path} = config_key_load(CONFIG_SECTION_ARCHIVE, CONFIG_KEY_PATH);
        }
    }

    # Set the log levels
    log_level_set(uc(config_key_load(CONFIG_SECTION_LOG, CONFIG_KEY_LEVEL_FILE, true, INFO)),
                  uc(config_key_load(CONFIG_SECTION_LOG, CONFIG_KEY_LEVEL_CONSOLE, true, ERROR)));

    # Validate config
    config_valid();

    # Set test parameters
    test_set(param_get(PARAM_TEST), param_get(PARAM_TEST_DELAY));
}

####################################################################################################################################
# CONFIG_STANZA_SECTION_LOAD - Get an entire stanza section
####################################################################################################################################
sub config_section_load
{
    my $strSection = shift;

    $strSection = param_get(PARAM_STANZA) . ':' . $strSection;

    return $oConfig{$strSection};
}

####################################################################################################################################
# CONFIG_KEY_LOAD - Get a value from the config and be sure that it is defined (unless bRequired is false)
####################################################################################################################################
sub config_key_load
{
    my $strSection = shift;
    my $strKey = shift;
    my $bRequired = shift;
    my $strDefault = shift;

    # Default is that the key is not required
    if (!defined($bRequired))
    {
        $bRequired = false;
    }

    my $strValue;

    # Look in the default stanza section
    if ($strSection eq CONFIG_SECTION_STANZA)
    {
        $strValue = $oConfig{param_get(PARAM_STANZA)}{"${strKey}"};
    }
    # Else look in the supplied section
    else
    {
        # First check the stanza section
        $strValue = $oConfig{param_get(PARAM_STANZA) . ":${strSection}"}{"${strKey}"};

        # If the stanza section value is undefined then check global
        if (!defined($strValue))
        {
            $strValue = $oConfig{"global:${strSection}"}{"${strKey}"};
        }
    }

    if (!defined($strValue) && $bRequired)
    {
        if (defined($strDefault))
        {
            return $strDefault;
        }

        confess &log(ERROR, 'config value ' . (defined($strSection) ? $strSection : '[stanza]') .  "->${strKey} is undefined");
    }

    if ($strSection eq CONFIG_SECTION_COMMAND)
    {
        my $strOption = config_key_load(CONFIG_SECTION_COMMAND_OPTION, $strKey);

        if (defined($strOption))
        {
            $strValue =~ s/\%option\%/${strOption}/g;
        }
    }

    return $strValue;
}


####################################################################################################################################
# CONFIG_VALID
#
# Make sure the configuration is valid.
####################################################################################################################################
sub config_valid
{
    # Local variables
    my $strSection;
    my $oSectionHashRef;

    # Check recovery:option section
    $strSection = param_get(PARAM_STANZA) . ':' . CONFIG_SECTION_RECOVERY_OPTION;
    $oSectionHashRef = $oConfig{$strSection};

    if (defined($oSectionHashRef) && keys($oSectionHashRef) != 0)
    {
        foreach my $strKey (sort(keys($oSectionHashRef)))
        {
            if ($strKey ne CONFIG_KEY_STANDBY_MODE &&
                $strKey ne CONFIG_KEY_PRIMARY_CONNINFO &&
                $strKey ne CONFIG_KEY_TRIGGER_FILE &&
                $strKey ne CONFIG_KEY_RESTORE_COMMAND &&
                $strKey ne CONFIG_KEY_ARCHIVE_CLEANUP_COMMAND &&
                $strKey ne CONFIG_KEY_RECOVERY_END_COMMAND)
            {
                confess &log(ERROR, "invalid key '${strKey}' for section '${strSection}', must be: '" .
                             CONFIG_KEY_STANDBY_MODE . "', '" . CONFIG_KEY_PRIMARY_CONNINFO . "', '" .
                             CONFIG_KEY_TRIGGER_FILE . "', '" . CONFIG_KEY_RESTORE_COMMAND . "', '" .
                             CONFIG_KEY_ARCHIVE_CLEANUP_COMMAND . "', '" . CONFIG_KEY_RECOVERY_END_COMMAND . "'", ERROR_CONFIG);
            }
        }
    }
}

####################################################################################################################################
# PARAM_VALID
#
# Make sure the command-line parameters are valid.
####################################################################################################################################
sub param_valid
{
    # Check the stanza
    if (!defined(param_get(PARAM_STANZA)))
    {
        confess 'a backup stanza must be specified';
    }

    # Check that the operation is present and valid
    if (!defined($strOperation))
    {
        confess &log(ERROR, "operation must be specified", ERROR_PARAM);
    }

    if ($strOperation ne OP_ARCHIVE_GET &&
        $strOperation ne OP_ARCHIVE_PUSH &&
        $strOperation ne OP_BACKUP &&
        $strOperation ne OP_RESTORE &&
        $strOperation ne OP_EXPIRE)
    {
        confess &log(ERROR, "invalid operation ${strOperation}");
    }

    # Check type param
    my $strParam = PARAM_TYPE;
    my $strType = param_get($strParam);

    # Type is only valid for backup and restore operations
    if (operation_test(OP_BACKUP) || operation_test(OP_RESTORE))
    {
        # Check types for backup
        if (operation_test(OP_BACKUP))
        {
            # If type is not defined set to BACKUP_TYPE_INCR
            if (!defined($strType))
            {
                $strType = BACKUP_TYPE_INCR;
                param_set($strParam, $strType);
            }

            # Check that type is in valid list
            if (!($strType eq BACKUP_TYPE_FULL || $strType eq BACKUP_TYPE_DIFF || $strType eq BACKUP_TYPE_INCR))
            {
                confess &log(ERROR, "invalid type '${strType}' for ${strOperation}, must be: '" . BACKUP_TYPE_FULL . "', '" .
                             BACKUP_TYPE_DIFF . "', '" . BACKUP_TYPE_INCR . "'", ERROR_PARAM);
            }
        }

        # Check types for restore
        elsif (operation_test(OP_RESTORE))
        {
            # If type is not defined set to RECOVERY_TYPE_DEFAULT
            if (!defined($strType))
            {
                $strType = RECOVERY_TYPE_DEFAULT;
                param_set($strParam, $strType);
            }

            if (!($strType eq RECOVERY_TYPE_NAME || $strType eq RECOVERY_TYPE_TIME || $strType eq RECOVERY_TYPE_XID ||
                  $strType eq RECOVERY_TYPE_PRESERVE || $strType eq RECOVERY_TYPE_NONE || $strType eq RECOVERY_TYPE_DEFAULT))
            {
                confess &log(ERROR, "invalid type '${strType}' for ${strOperation}, must be: '" . RECOVERY_TYPE_NAME .
                             "', '" . RECOVERY_TYPE_TIME . "', '" . RECOVERY_TYPE_XID . "', '" . RECOVERY_TYPE_PRESERVE .
                             "', '" . RECOVERY_TYPE_NONE . "', '" . RECOVERY_TYPE_DEFAULT . "'", ERROR_PARAM);
            }
        }
    }
    else
    {
        if (defined($strType))
        {
            confess &log(ERROR, PARAM_TYPE . ' is only valid for '. OP_BACKUP . ' and ' . OP_RESTORE . ' operations', ERROR_PARAM);
        }
    }

    # Check target param
    $strParam = PARAM_TARGET;
    my $strTarget = param_get($strParam);
    my $strTargetMessage = 'for ' . OP_RESTORE . " operations where type is '" . RECOVERY_TYPE_NAME .
                           "', '" . RECOVERY_TYPE_TIME . "', or '" . RECOVERY_TYPE_XID . "'";

    if (operation_test(OP_RESTORE) &&
        ($strType eq RECOVERY_TYPE_NAME || $strType eq RECOVERY_TYPE_TIME || $strType eq RECOVERY_TYPE_XID))
    {
         if (!defined($strTarget))
         {
             confess &log(ERROR, PARAM_TARGET . ' is required ' . $strTargetMessage, ERROR_PARAM);
         }
    }
    elsif (defined($strTarget))
    {
        confess &log(ERROR, PARAM_TARGET . ' is only required ' . $strTargetMessage, ERROR_PARAM);
    }

    # Check target-resume - can only be used when target is specified
    if (defined(param_get(PARAM_TARGET_RESUME)) && !defined($strTarget))
    {
        confess &log(ERROR, PARAM_TARGET_RESUME . ' and ' . PARAM_TARGET_TIMELINE .
                            ' are only valid when target is specified', ERROR_PARAM);
    }

    # Check target-exclusive - can only be used when target is time or xid
    if (defined(param_get(PARAM_TARGET_EXCLUSIVE)) && !($strType eq RECOVERY_TYPE_TIME || $strType eq RECOVERY_TYPE_XID))
    {
        confess &log(ERROR, PARAM_TARGET_EXCLUSIVE . ' is only valid when target is specified and recovery type is ' .
                            RECOVERY_TYPE_TIME . ' or ' . RECOVERY_TYPE_XID, ERROR_PARAM);
    }
}

####################################################################################################################################
# OPERATION_GET
#
# Get the current operation.
####################################################################################################################################
sub operation_get
{
    return $strOperation;
}

####################################################################################################################################
# OPERATION_TEST
#
# Test the current operation.
####################################################################################################################################
sub operation_test
{
    my $strOperationTest = shift;

    return $strOperationTest eq $strOperation;
}

####################################################################################################################################
# OPERATION_SET
#
# Set current operation (usually for triggering follow-on operations).
####################################################################################################################################
sub operation_set
{
    my $strValue = shift;

    $strOperation = $strValue;
}

####################################################################################################################################
# PARAM_GET
#
# Get param value.
####################################################################################################################################
sub param_get
{
    my $strParam = shift;

    return $oParam{$strParam};
}

####################################################################################################################################
# PARAM_SET
#
# Set param value.
####################################################################################################################################
sub param_set
{
    my $strParam = shift;
    my $strValue = shift;

    $oParam{$strParam} = $strValue;
}

1;
