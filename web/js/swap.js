
var flashSwapContract = 'TGS7NxoAQ44pQYCSAW3FPrVMhQ1TpdsTXg';

async function getTokenBalance(index, tokenType, tokenAddress, userAddress) {
    if (tokenType == '1') {
        tronWeb.trx.getUnconfirmedBalance(userAddress).then(result => {
        let balance = result;
        setBalance(index, tokenAddress, balance);
        });
    } else {
        let obj = await tronWeb.contract().at(flashSwapContract);
        let balance = await obj.getBalanceOfToken(tokenAddress, userAddress).call();
        setBalance(index, tokenAddress, balance);
    }
}

async function allowance(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, userAddress, swapTradeValue, baseTradeValue) {
    console.log('allowance lpTokenAddress 002: ' + lpTokenAddress);
    console.log('allowance swapTokenType: ' + swapTokenType);
    console.log('allowance baseTokenType: ' + baseTokenType);
    console.log('allowance swapTokenAddress: ' + swapTokenAddress);
    console.log('allowance baseTokenAddress: ' + baseTokenAddress);
    console.log('allowance userAddress: ' + userAddress);
    console.log('allowance swapTradeValue: ' + swapTradeValue);
    console.log('allowance baseTradeValue: ' + baseTradeValue);
    let obj = await tronWeb.contract().at(swapTokenAddress);
    let result = await obj.allowance(userAddress, flashSwapContract).call();
    setAllowance(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue, result);
}


async function approve(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue) {
    console.log('approve lpTokenAddress: ' + lpTokenAddress);
    console.log('approve swapTokenType: ' + swapTokenType);
    console.log('approve baseTokenType: ' + baseTokenType);
    console.log('approve swapTokenAddress: ' + swapTokenAddress);
    console.log('approve baseTokenAddress: ' + baseTokenAddress);
    console.log('approve swapTradeValue: ' + swapTradeValue);
    console.log('approve baseTradeValue: ' + baseTradeValue);

    let obj = await tronWeb.contract().at(swapTokenAddress);
    let result = await obj.approve(flashSwapContract, '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff').send({
        feeLimit: 10000000
    });

    setApprove(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue);
}

async function tokenToTrxSwap(swapToken, lpToken, tokensSold, minTrx, userAddress) {
    console.log('tokenToTrxSwap swapToken: ' + swapToken);
    console.log('tokenToTrxSwap lpToken: ' + lpToken);
    console.log('tokenToTrxSwap tokensSold: ' + tokensSold);
    console.log('tokenToTrxSwap minTrx: ' + minTrx);
    console.log('tokenToTrxSwap userAddress: ' + userAddress);
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await obj.tokenToTrxSwap(swapToken, lpToken, tokensSold.toString(), minTrx.toString(), userAddress).send({
        feeLimit: 10000000
    });
    console.log('tokenToTrxSwap result: ' + result);
}
