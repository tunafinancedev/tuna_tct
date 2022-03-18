// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "Ownable: you don't have permission to unlock");
        require(block.timestamp > _lockTime , "Ownable: can not unlock now");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, 
        uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, 
        address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin,
        address to,
        uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract TCT is ERC20, Ownable {
    using Address for address;
    using SafeMath for uint256;

    uint256 public constant VERSION = 1;

    address public creator;
    address public _router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public constant BLACKHOLE = address(0xdead);

    string public constant NAME = "TCT";
    string public constant SYMBOL = "TCT";
    uint256 public constant ISSUE = 100000000;


    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    bool public swapping;

    uint256 public addLiquidTokensAtAmount;

    uint256 public constant PRECISION = 100;

    uint256 public destoryFee; // 1
    uint256 public bitFee; // 1
    uint256 public liquidFee; // 2
    uint256 public marketingFee; // 1
    uint256 public inviterFee; // 5
    uint256 public swapTotalFees; // 10 in total
    uint8[] public rates; // inviter rates
    uint8 public ratesSum;

    address private root;
    address private marketingWallet; 
    address private bitWallet;
    address private projectWallet;
    
    mapping(address => bool) public isExcludedFromFees;
    mapping(address => bool) public automatedMarketMakerPairs;
    mapping(address => bool) public blockList;

    bool public tradingIsEnabled = false;
    
    uint256 public recommendRequire = 0;
    uint256 public _maxTxAmount;
    uint256 public sellRateLimit;
    
    uint256 public transferGasLimit = 23000;
    
    mapping(address => uint256) public inviterLockTime;
    mapping(address => address) public inviter;
    
    uint256 public inviterRequireLockTime;

    bool public blockContractTransferTo = true;
    mapping(address => bool) public whiteContractTransferTo;

    event UpdateUniswapV2Router(
        address indexed newAddress,
        address indexed oldAddress
    );

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event LiquidityWalletUpdated(
        address indexed newLiquidityWallet,
        address indexed oldLiquidityWallet
    );

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    event SetInviter(
        address indexed user,
        address indexed inviter,
        uint256 timestamp,
        bool sys
    );

    constructor(
        address[4] memory addrs_, 
        uint256[5] memory feeSettings_, 
        uint256 recommendRequire_, 
        uint256 sellRateLimit_, 
        uint256 inviterRequireLockTime_
    ) public ERC20(NAME, SYMBOL) {
        creator = owner();

        root = addrs_[0];
        marketingWallet = addrs_[1];
        bitWallet = addrs_[2];
        projectWallet = addrs_[3];

        destoryFee = feeSettings_[0]; // 1
        bitFee = feeSettings_[1]; // 1
        marketingFee = feeSettings_[2]; // 1
        inviterFee = feeSettings_[3]; // 5 
        liquidFee = feeSettings_[4]; //2
        swapTotalFees = destoryFee.add(bitFee).add(liquidFee).add(marketingFee).add(inviterFee); //10
        rates = [8, 8, 8, 8, 8, 2, 2, 2, 2, 2]; // 50

        for (uint8 i=0; i<rates.length;i++){
            ratesSum += rates[i];
        }
        
        _maxTxAmount = 500000 * 10**uint256(decimals());

        recommendRequire = recommendRequire_ * 10**uint256(14);
        sellRateLimit = sellRateLimit_;
        inviterRequireLockTime = inviterRequireLockTime_;

        uint256 totalSupply_ = ISSUE * 10**uint256(decimals());
        addLiquidTokensAtAmount = 50000 * 10**uint256(decimals());

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
        
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
        
        _excludeFromFees(owner(), true);
        _excludeFromFees(address(this), true);

        _mint(owner(), totalSupply_);

        _setWhiteContractTransferTo(address(uniswapV2Router), true);
        _setWhiteContractTransferTo(address(uniswapV2Pair), true);
    }

    function _setWhiteContractTransferTo(address ct, bool value) private {
        whiteContractTransferTo[ct] = value;
    }

    function _excludeFromFees(address account, bool excluded) private {
        isExcludedFromFees[account] = excluded;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(
            automatedMarketMakerPairs[pair] != value,
            "CCC: Automated market maker pair is already set to that value"
        );
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    receive() external payable {}

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (to.isContract()) {
            
            if (blockContractTransferTo) {
                require(
                    whiteContractTransferTo[to] || from == owner(),
                    "CCC: not allow transfer to contract"
                );
            }
        }
        
        bool isMng = isExcludedFromFees[from] || isExcludedFromFees[to];
        
        if (!isMng) {
            require(!blockList[from] && !blockList[to], "CCC: block");
        }

        
        if (!tradingIsEnabled && !isMng) {
            require(
                !automatedMarketMakerPairs[from] &&
                    !automatedMarketMakerPairs[to],
                "CCC: trading is not enable"
            );
        }

        
        if (address(uniswapV2Router) == to && !isMng) {
            if (sellRateLimit < PRECISION) {
                require(
                    amount <= balanceOf(from).mul(sellRateLimit).div(PRECISION)
                ); 
            }
        }
                
        bool shouldSetInviter = balanceOf(to) == 0 &&
            inviter[to] == address(0) &&
            !from.isContract() && !to.isContract() && to != creator; 

        if (shouldSetInviter) {
            inviter[to] = from;
            inviterLockTime[to] = block.timestamp; 
            emit SetInviter(to, from, block.timestamp, false);
        }

        // swapAndliquid
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwapAndLiquid = contractTokenBalance >= addLiquidTokensAtAmount;
        if (canSwapAndLiquid && !swapping && !automatedMarketMakerPairs[from] && !isMng) {
            //selling
            swapping = true;
            _swapAndLiquid(contractTokenBalance);
            swapping = false;
        }
        
        bool isSwap = automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]; 

        if (isSwap) {

            if (tradingIsEnabled && !isMng) {
                checkTxLimit(amount);
            }

            bool takeFee = !swapping && !isMng; 
            address user = automatedMarketMakerPairs[from] ? to : from; 

            if (!user.isContract() && (user != creator)) {
                if (inviter[user] == address(0)) {
                    inviter[user] = root; 
                    inviterLockTime[user] = block.timestamp;
                    emit SetInviter(user, root, block.timestamp, true);
                } else {
                    if (inviterLockTime[user] > (block.timestamp - inviterRequireLockTime) && inviter[user] != root) {
                        inviter[user] = root;
                        inviterLockTime[user] = block.timestamp;
                        emit SetInviter(user, root, block.timestamp, true);
                    }
                }
            }

            if (takeFee) {

                uint256 fees = amount.mul(swapTotalFees).div(PRECISION); // burn + bit + marketing + invite + liquid = 10%
                amount = amount.sub(fees);
                super._transfer(from, address(this), fees); 

                // burn 1%
                if (destoryFee > 0){
                    super._transfer(address(this), BLACKHOLE, fees.mul(destoryFee).div(swapTotalFees));
                }

                uint256 multiFees = marketingFee.add(bitFee).add(inviterFee);
                if (multiFees > 0) {
                    if (automatedMarketMakerPairs[from]) {
                        //buying
                        //invite 5%
                        if (inviterFee > 0){
                            _sendTCTRecomm(to, fees.mul(inviterFee).div(swapTotalFees));
                        }
                        // marketing 1%
                        if (marketingFee > 0){
                            super._transfer(address(this), marketingWallet, fees.mul(marketingFee).div(swapTotalFees));
                        }
                        // bit 1%
                        if (bitFee > 0){
                            super._transfer(address(this), bitWallet, fees.mul(bitFee).div(swapTotalFees)); 
                        }
                    }else{
                        //selling
                        swapping = true;
                        _swapAndSendBNB(from, fees.mul(multiFees).div(swapTotalFees));
                        swapping = false;
                    }
                }
            }
        }

        super._transfer(from, to, amount);
    }

    function checkTxLimit(uint256 amount) internal view {
        require(amount <= _maxTxAmount, "TX Limit Exceeded");
    }

    function _swapTokensForBNB(uint256 tokens) private {
        
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokens);

        
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokens,
            0, 
            path,
            address(this),
            block.timestamp
        );
    }


    function _sendTCTRecomm(address from, uint256 tokens) private {
        
        if (balanceOf(address(this)) < tokens) {
            return;
        }
        uint256 use = 0;
        address index = inviter[from];
        for (uint256 i = 0; i < rates.length; i++) {
            if (index == address(0)) {
                break;
            }
            if (balanceOf(index) < recommendRequire) {
                index = inviter[index];
                continue;
            }
            
            uint256 reward = tokens.mul(rates[i]).div(ratesSum);
            
            if (balanceOf(address(this)) >= reward) {
                use = use.add(reward);
                super._transfer(address(this), index, reward);
            } else {
                break;
            }
            index = inviter[index];
        }
        
        if (tokens > use) {
            uint256 tmp = tokens.sub(use);
            if (balanceOf(address(this)) >= tmp) {
                super._transfer(address(this), projectWallet, tmp);
            }
        }
    }


    function _swapAndSendBNB(address from, uint256 tokens) private returns (bool){

        if (balanceOf(address(this)) < tokens) {
            return false;
        }

        uint256 initialBalance = address(this).balance;
        _swapTokensForBNB(tokens);
        uint256 newBalance = address(this).balance.sub(initialBalance); // includes invitebnb marketingbnb bitbnb
        uint256 multiFee = inviterFee.add(marketingFee).add(bitFee);
        // marketing
        if (marketingFee > 0){
            uint256 market_reward = newBalance.mul(marketingFee).div(multiFee);
            (bool s1, ) = address(marketingWallet).call{
                value: market_reward,
                gas: transferGasLimit
            }("");
            if (s1) {
                newBalance = newBalance.sub(market_reward);
            }
        }

        // bit
        if (bitFee > 0){
            uint256 bit_reward = newBalance.mul(bitFee).div(multiFee);
            (bool s2, ) = address(bitWallet).call{
                value: bit_reward,
                gas: transferGasLimit
            }("");
            if (s2) {
                newBalance = newBalance.sub(bit_reward);
            }
        }

        
        uint256 use = 0;
        address index = inviter[from];
        for (uint256 i = 0; i < rates.length; i++) {
            if (index == address(0)) {
                break;
            }
            if (balanceOf(index) < recommendRequire) {
                index = inviter[index];
                continue;
            }
           
            uint256 reward = newBalance.mul(rates[i]).div(ratesSum);
            if (address(this).balance >= reward) {
                (bool success, ) = address(index).call{
                    value: reward,
                    gas: transferGasLimit
                }("");
                if (success) {
                    use = use.add(reward);
                }
            } else {
                break;
            }
            index = inviter[index];
        }
        
        if (newBalance > use) {
            uint256 tmp = newBalance.sub(use);
            if (address(this).balance >= tmp) {
                (bool success, ) = address(projectWallet).call{
                    value: tmp,
                    gas: transferGasLimit
                }("");
                return success;
            }
        }
        return true;
    }

    function setAddLiquidTokensAtAmount(uint256 amount) external onlyOwner {
        addLiquidTokensAtAmount = amount;
    }

    function _swapAndLiquid(uint256 contractTokenBalance) private {
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
        
        uint256 initialBalance = address(this).balance;
        // swap tokens for ETH
        _swapTokensForBNB(half);
        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);
        
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), otherHalf);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: newBalance}(
            address(this),
            otherHalf,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            creator,
            block.timestamp
        );

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }
    
    function updateUniswapV2Router(address newAddress) external onlyOwner {
        require(
            newAddress != address(uniswapV2Router),
            "CCC: The router already has that address"
        );
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
        address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
            .createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Pair = _uniswapV2Pair;
    }

    function excludeFromFees(address account, bool excluded)
        external
        onlyOwner
    {
        _excludeFromFees(account, excluded);
        emit ExcludeFromFees(account, excluded);
    }

    function excludeMultipleAccountsFromFees(
        address[] calldata accounts,
        bool excluded
    ) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _excludeFromFees(accounts[i], excluded);
        }
        emit ExcludeMultipleAccountsFromFees(accounts, excluded);
    }

    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner{
        require(
            pair != uniswapV2Pair,
            "CCC: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
    }

    function setMarketingFee(uint256 value) external onlyOwner {
        marketingFee = value;
        _updateSwapTotalFees();
    }

    function setInviterFee(uint256 value) external onlyOwner {
        inviterFee = value;
        _updateSwapTotalFees();
    }

    function setMaxTxAmount(uint256 value) external onlyOwner {
        _maxTxAmount = value;
    }

    function setDestoryFee(uint256 value) external onlyOwner {
        destoryFee = value;
        _updateSwapTotalFees();
    }

    function setBitFee(uint256 value) external onlyOwner {
        bitFee = value;
        _updateSwapTotalFees();
    }

    function _updateSwapTotalFees() private {
        swapTotalFees = marketingFee.add(bitFee).add(inviterFee).add(destoryFee);
    }

    function setTradingEnabled(bool flag) external onlyOwner {
        tradingIsEnabled = flag;
    }

    function setRecommendRequire(uint256 value) external onlyOwner {
        recommendRequire = value;
    }

    function setInviter(address from, address to) external onlyOwner {
            inviter[to] = from;
    }

    function setSellRateLimit(uint256 value) external onlyOwner {
        sellRateLimit = value;
    }

    function setRoot(address addr) external onlyOwner {
        root = addr;
    }

    function setBitWallet(address addr) external onlyOwner {
        bitWallet = addr;
    }

    function setMarketingWallet(address wallet) external onlyOwner {
        marketingWallet = wallet;
    }

    function setProjectWallet(address addr) external onlyOwner {
        projectWallet = addr;
    }

    function addToBlockList(address account, bool status) external onlyOwner {
        blockList[account] = status;
    }

    function addMultipleToBlockList(address[] calldata accounts, bool status)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            blockList[accounts[i]] = status;
        }
    }

    function setInviterRequireLockTime(uint256 value) external onlyOwner {
        inviterRequireLockTime = value;
    }

    function setWhiteContractTransferTo(address ct, bool value)
        external
        onlyOwner
    {
        _setWhiteContractTransferTo(ct, value);
    }

    function setBlockContractTransferTo(bool value) external onlyOwner {
        blockContractTransferTo = value;
    }
}
