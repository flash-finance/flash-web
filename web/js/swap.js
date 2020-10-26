
var flashSwapContract = 'TGS7NxoAQ44pQYCSAW3FPrVMhQ1TpdsTXg';

async function getTokenBalance(index, tokenType, tokenAddress, userAddress) {
    if (tokenType == '1') {
        tronWeb.trx.getUnconfirmedBalance(userAddress).then(result => {
        let balance = result;
        setBalance(index, balance);
        });
    } else {
        let obj = await tronWeb.contract().at(flashSwapContract);
        let balance = await obj.getBalanceOfToken(tokenAddress, userAddress).call();
        setBalance(index, balance);
    }

 }
