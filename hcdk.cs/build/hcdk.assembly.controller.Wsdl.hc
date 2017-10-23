<?php #HYPERCELL hcdk.assembly.controller.Wsdl - BUILD 17.10.11#170
namespace hcdk\assembly\controller;
class Wsdl extends \hcdk\assembly\controller {
    use \hcf\core\dryver\Base, Wsdl\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.controller.Wsdl';
    const NAME = 'Wsdl';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function build__invoke() {
        $output = "
\$soap_server = null;
\$wsdl = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$this->_call('getName') }', '{$this->_call('getType') }');
\$wsdl_path = 'data://text/plain;base64,'.base64_encode(\$wsdl);

if(isset(\$soap_server_options))
{
	\$soap_server = new \SoapServer(\$wsdl_path, \$soap_server_options);
}
else
{
	\$soap_server = new \SoapServer(\$wsdl_path);
}

\$soap_server->setObject(\$this);

return \$soap_server;
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\controller\Wsdl\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    public function getType() {
        return 'WSDL';
    }
    public function isAttachment() {
        return true;
    }
    public function isExecutable() {
        return false;
    }
    private function buildSoapServer() {
        // TODO this must be onInvoke and a controller.php must be used for the server-methods?
        $method = new Method('__invoke', ['public']);
        $method->setArguments(['soap_server_options' => null]);
        $method->setBody($this->build__invoke());
        return $method->toString();
    }
    protected function getControllerMethods() {
        return ['__invoke' => $this->buildSoapServer() ];
    }
    protected function getStaticControllerMethods() {
        return null;
    }
    protected function getControllerTrait() {
        return null; //['Controller' => '\\hcf\\core\\dryver\\Controller'];
        
    }
    protected function getConstructorContents() {
        return null;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>


