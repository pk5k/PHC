<?php #HYPERCELL hcf.core.log.Internal - BUILD 22.01.24#181
namespace hcf\core\log;
class Internal {
    use \hcf\core\dryver\Log, \hcf\core\dryver\Internal;
    const FQN = 'hcf.core.log.Internal';
    const NAME = 'Internal';
    public function __construct() {
    }
    # BEGIN ASSEMBLY FRAME LOG.XML
    protected static function getLogAttachment() {
        return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'LOG', 'XML');
    }
    # END ASSEMBLY FRAME LOG.XML
    
    }
    namespace hcf\core\log\Internal\__EO__;
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[LOG.XML]

<configuration xmlns="http://logging.apache.org/log4php/">
    <appender name="hcf.core.log.Internal" class="LoggerAppenderRollingFile">
        <layout class="LoggerLayoutPattern">
            <param name="conversionPattern" value="%date %logger %-5level %msg%n"/>
        </layout>
        <param name="file" value="hcf.log" />
        <param name="maxFileSize" value="1MB" />
        <param name="maxBackupIndex" value="5" />
    </appender>
    <root>
        <appender_ref ref="hcf.core.log.Internal" />
    </root>
</configuration>

END[LOG.XML]


?>


