####################################################################################################################################
# Automatically generated by Build.pm -- do not modify directly.
####################################################################################################################################
package pgBackRest::LibCAuto;

# Library version (.999 indicates development version)
sub libcAutoVersion
{
    return '1.26.999';
}

# Configuration option value constants
sub libcAutoConstant
{
    return 
    {
        CFGOPTVAL_INFO_OUTPUT_TEXT                                       => 'text',
        CFGOPTVAL_INFO_OUTPUT_JSON                                       => 'json',

        CFGOPTVAL_REPO_TYPE_CIFS                                         => 'cifs',
        CFGOPTVAL_REPO_TYPE_POSIX                                        => 'posix',
        CFGOPTVAL_REPO_TYPE_S3                                           => 's3',

        CFGOPTVAL_RETENTION_ARCHIVE_TYPE_FULL                            => 'full',
        CFGOPTVAL_RETENTION_ARCHIVE_TYPE_DIFF                            => 'diff',
        CFGOPTVAL_RETENTION_ARCHIVE_TYPE_INCR                            => 'incr',

        CFGOPTVAL_RESTORE_TARGET_ACTION_PAUSE                            => 'pause',
        CFGOPTVAL_RESTORE_TARGET_ACTION_PROMOTE                          => 'promote',
        CFGOPTVAL_RESTORE_TARGET_ACTION_SHUTDOWN                         => 'shutdown',

        CFGOPTVAL_BACKUP_TYPE_FULL                                       => 'full',
        CFGOPTVAL_BACKUP_TYPE_DIFF                                       => 'diff',
        CFGOPTVAL_BACKUP_TYPE_INCR                                       => 'incr',

        CFGOPTVAL_LOCAL_TYPE_DB                                          => 'db',
        CFGOPTVAL_LOCAL_TYPE_BACKUP                                      => 'backup',

        CFGOPTVAL_REMOTE_TYPE_DB                                         => 'db',
        CFGOPTVAL_REMOTE_TYPE_BACKUP                                     => 'backup',

        CFGOPTVAL_RESTORE_TYPE_NAME                                      => 'name',
        CFGOPTVAL_RESTORE_TYPE_TIME                                      => 'time',
        CFGOPTVAL_RESTORE_TYPE_XID                                       => 'xid',
        CFGOPTVAL_RESTORE_TYPE_PRESERVE                                  => 'preserve',
        CFGOPTVAL_RESTORE_TYPE_NONE                                      => 'none',
        CFGOPTVAL_RESTORE_TYPE_IMMEDIATE                                 => 'immediate',
        CFGOPTVAL_RESTORE_TYPE_DEFAULT                                   => 'default',
    }
}

# Export function and constants
sub libcAutoExportTag
{
    return
    {
        checksum =>
        [
            'pageChecksum',
            'pageChecksumBufferTest',
            'pageChecksumTest',
        ],

        config =>
        [
            'CFGOPTVAL_INFO_OUTPUT_TEXT',
            'CFGOPTVAL_INFO_OUTPUT_JSON',
            'CFGOPTVAL_REPO_TYPE_CIFS',
            'CFGOPTVAL_REPO_TYPE_POSIX',
            'CFGOPTVAL_REPO_TYPE_S3',
            'CFGOPTVAL_RETENTION_ARCHIVE_TYPE_FULL',
            'CFGOPTVAL_RETENTION_ARCHIVE_TYPE_DIFF',
            'CFGOPTVAL_RETENTION_ARCHIVE_TYPE_INCR',
            'CFGOPTVAL_RESTORE_TARGET_ACTION_PAUSE',
            'CFGOPTVAL_RESTORE_TARGET_ACTION_PROMOTE',
            'CFGOPTVAL_RESTORE_TARGET_ACTION_SHUTDOWN',
            'CFGOPTVAL_BACKUP_TYPE_FULL',
            'CFGOPTVAL_BACKUP_TYPE_DIFF',
            'CFGOPTVAL_BACKUP_TYPE_INCR',
            'CFGOPTVAL_LOCAL_TYPE_DB',
            'CFGOPTVAL_LOCAL_TYPE_BACKUP',
            'CFGOPTVAL_REMOTE_TYPE_DB',
            'CFGOPTVAL_REMOTE_TYPE_BACKUP',
            'CFGOPTVAL_RESTORE_TYPE_NAME',
            'CFGOPTVAL_RESTORE_TYPE_TIME',
            'CFGOPTVAL_RESTORE_TYPE_XID',
            'CFGOPTVAL_RESTORE_TYPE_PRESERVE',
            'CFGOPTVAL_RESTORE_TYPE_NONE',
            'CFGOPTVAL_RESTORE_TYPE_IMMEDIATE',
            'CFGOPTVAL_RESTORE_TYPE_DEFAULT',
            'CFGCMD_ARCHIVE_GET',
            'CFGCMD_ARCHIVE_PUSH',
            'CFGCMD_BACKUP',
            'CFGCMD_CHECK',
            'CFGCMD_EXPIRE',
            'CFGCMD_HELP',
            'CFGCMD_INFO',
            'CFGCMD_LOCAL',
            'CFGCMD_REMOTE',
            'CFGCMD_RESTORE',
            'CFGCMD_STANZA_CREATE',
            'CFGCMD_STANZA_UPGRADE',
            'CFGCMD_START',
            'CFGCMD_STOP',
            'CFGCMD_VERSION',
            'CFGOPT_ARCHIVE_ASYNC',
            'CFGOPT_ARCHIVE_CHECK',
            'CFGOPT_ARCHIVE_COPY',
            'CFGOPT_ARCHIVE_MAX_MB',
            'CFGOPT_ARCHIVE_QUEUE_MAX',
            'CFGOPT_ARCHIVE_TIMEOUT',
            'CFGOPT_BACKUP_CMD',
            'CFGOPT_BACKUP_CONFIG',
            'CFGOPT_BACKUP_HOST',
            'CFGOPT_BACKUP_SSH_PORT',
            'CFGOPT_BACKUP_STANDBY',
            'CFGOPT_BACKUP_USER',
            'CFGOPT_BUFFER_SIZE',
            'CFGOPT_CHECKSUM_PAGE',
            'CFGOPT_CMD_SSH',
            'CFGOPT_COMMAND',
            'CFGOPT_COMPRESS',
            'CFGOPT_COMPRESS_LEVEL',
            'CFGOPT_COMPRESS_LEVEL_NETWORK',
            'CFGOPT_CONFIG',
            'CFGOPT_DB_CMD',
            'CFGOPT_DB_CONFIG',
            'CFGOPT_DB_HOST',
            'CFGOPT_DB_INCLUDE',
            'CFGOPT_DB_PATH',
            'CFGOPT_DB_PORT',
            'CFGOPT_DB_SOCKET_PATH',
            'CFGOPT_DB_SSH_PORT',
            'CFGOPT_DB_TIMEOUT',
            'CFGOPT_DB_USER',
            'CFGOPT_DELTA',
            'CFGOPT_FORCE',
            'CFGOPT_HARDLINK',
            'CFGOPT_HOST_ID',
            'CFGOPT_LINK_ALL',
            'CFGOPT_LINK_MAP',
            'CFGOPT_LOCK_PATH',
            'CFGOPT_LOG_LEVEL_CONSOLE',
            'CFGOPT_LOG_LEVEL_FILE',
            'CFGOPT_LOG_LEVEL_STDERR',
            'CFGOPT_LOG_PATH',
            'CFGOPT_LOG_TIMESTAMP',
            'CFGOPT_MANIFEST_SAVE_THRESHOLD',
            'CFGOPT_NEUTRAL_UMASK',
            'CFGOPT_ONLINE',
            'CFGOPT_OUTPUT',
            'CFGOPT_PROCESS',
            'CFGOPT_PROCESS_MAX',
            'CFGOPT_PROTOCOL_TIMEOUT',
            'CFGOPT_RECOVERY_OPTION',
            'CFGOPT_REPO_PATH',
            'CFGOPT_REPO_S3_BUCKET',
            'CFGOPT_REPO_S3_CA_FILE',
            'CFGOPT_REPO_S3_CA_PATH',
            'CFGOPT_REPO_S3_ENDPOINT',
            'CFGOPT_REPO_S3_HOST',
            'CFGOPT_REPO_S3_KEY',
            'CFGOPT_REPO_S3_KEY_SECRET',
            'CFGOPT_REPO_S3_REGION',
            'CFGOPT_REPO_S3_VERIFY_SSL',
            'CFGOPT_REPO_TYPE',
            'CFGOPT_RESUME',
            'CFGOPT_RETENTION_ARCHIVE',
            'CFGOPT_RETENTION_ARCHIVE_TYPE',
            'CFGOPT_RETENTION_DIFF',
            'CFGOPT_RETENTION_FULL',
            'CFGOPT_SET',
            'CFGOPT_SPOOL_PATH',
            'CFGOPT_STANZA',
            'CFGOPT_START_FAST',
            'CFGOPT_STOP_AUTO',
            'CFGOPT_TABLESPACE_MAP',
            'CFGOPT_TABLESPACE_MAP_ALL',
            'CFGOPT_TARGET',
            'CFGOPT_TARGET_ACTION',
            'CFGOPT_TARGET_EXCLUSIVE',
            'CFGOPT_TARGET_TIMELINE',
            'CFGOPT_TEST',
            'CFGOPT_TEST_DELAY',
            'CFGOPT_TEST_POINT',
            'CFGOPT_TYPE',
            'cfgCommandName',
            'cfgOptionIndex',
            'cfgOptionIndexTotal',
            'cfgOptionName',
        ],

        configDefine =>
        [
            'CFGDEF_TYPE_BOOLEAN',
            'CFGDEF_TYPE_FLOAT',
            'CFGDEF_TYPE_HASH',
            'CFGDEF_TYPE_INTEGER',
            'CFGDEF_TYPE_LIST',
            'CFGDEF_TYPE_STRING',
            'cfgCommandId',
            'cfgDefOptionAllowList',
            'cfgDefOptionAllowListValue',
            'cfgDefOptionAllowListValueTotal',
            'cfgDefOptionAllowListValueValid',
            'cfgDefOptionAllowRange',
            'cfgDefOptionAllowRangeMax',
            'cfgDefOptionAllowRangeMin',
            'cfgDefOptionDefault',
            'cfgDefOptionDepend',
            'cfgDefOptionDependOption',
            'cfgDefOptionDependValue',
            'cfgDefOptionDependValueTotal',
            'cfgDefOptionDependValueValid',
            'cfgDefOptionNameAlt',
            'cfgDefOptionNegate',
            'cfgDefOptionPrefix',
            'cfgDefOptionRequired',
            'cfgDefOptionSection',
            'cfgDefOptionSecure',
            'cfgDefOptionType',
            'cfgDefOptionValid',
            'cfgOptionId',
            'cfgOptionTotal',
        ],

        debug =>
        [
            'UVSIZE',
            'libcVersion',
        ],

        encode =>
        [
            'ENCODE_TYPE_BASE64',
            'decodeToBin',
            'encodeToStr',
        ],
    }
}

1;
