<?php #HYPERCELL hcdk.assembly.client.Wsdl - BUILD 17.10.11#167
namespace hcdk\assembly\client;
class Wsdl extends \hcdk\assembly\client {
    use \hcf\core\dryver\Base, Wsdl\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.client.Wsdl';
    const NAME = 'Wsdl';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildClientMethod() {
        $output = "
\$soap_client = null;
\$wsdl = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$this->_call('getName') }', '{$this->_call('getType') }');
\$wsdl_path = 'data://text/plain;base64,'.base64_encode(\$wsdl);

if(isset(\$soap_client_options))
{
	\$soap_client = new \SoapClient(\$wsdl_path, \$soap_client_options);
}
else
{
	\$soap_client = new \SoapClient(\$wsdl_path);
}

return \$soap_client;
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\client\Wsdl\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    public function getType() {
        return 'WSDL';
    }
    public function sourceIsAttachment() {
        return true;
    }
    public function buildClient() {
        $method = new Method('client', ['public', 'static']);
        $method->setArguments(['soap_client_options' => null]);
        $method->setBody($this->buildClientMethod('client', 'wsdl'));
        return $method->toString();
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>


