

async function getAmount4Farm(index, account, tokenAddress, poolAddress) {
    console.log('index: '+ index + '; account: ' + account + '; tokenAddress: ' + tokenAddress + '; poolAddress: ' + poolAddress);
    let balanceAmount = '0';
    let code = 0;
    if (index == '0') {
        tronWeb.trx.getUnconfirmedBalance(account).then(result => {
            balanceAmount = result;
        }).catch(e => {
                console.log('getUnconfirmedBalance error:' + JSON.stringify(e));
                code = 1;
               });
    } else {
        let tokenObj = await tronWeb.contract().at(tokenAddress);
        balanceAmount = await tokenObj.balanceOf(account).call().catch(e => {
            console.log('balanceOf error:' + JSON.stringify(e));
            code = 1;
        });
    }

    let poolObj = await tronWeb.contract().at(poolAddress);
    let depositedAmount = await poolObj.balanceOf(account).call().catch(e => {
        console.log('balanceOf error:' + JSON.stringify(e));
        code = 1;
    });
    let harvestedAmount = await poolObj.earned(account).call().catch(e => {
        console.log('balanceOf error:' + JSON.stringify(e));
        code = 1;
    });

     if (code == 1) {
         return;
     }

    setTokenAmount4Farm(index, tokenAddress, balanceAmount, depositedAmount, harvestedAmount);
 }


async function allowance(tokenType, stakeAmount, account, tokenAddress, poolAddress) {
    let tokenObj = await tronWeb.contract().at(tokenAddress);
    let result = await tokenObj.allowance(account, poolAddress).call();
    setAllowance(tokenType, stakeAmount, tokenAddress, poolAddress, result);
}

async function approve(tokenType, stakeAmount, tokenAddress, poolAddress) {
    let tokenObj = await tronWeb.contract().at(tokenAddress);
    let result = await tokenObj.approve(poolAddress, '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff').send({
        feeLimit: 10000000
    });

    setStake(tokenType, stakeAmount, poolAddress);
}


async function stake(tokenType, amount, poolAddress) {
    let poolObj = await tronWeb.contract().at(poolAddress);
    let result = '';
    if (tokenType == '1') {
        result = await poolObj.stake().send({
         callValue: amount.toString(),
         feeLimit: 10000000
        });
    } else {
        result = await poolObj.stake(amount.toString()).send({
        feeLimit: 10000000
       });
    }

    console.log("stake result: " + result);
    setHash(1, result);
}


async function withdraw(amount, poolAddress) {
    let poolObj = await tronWeb.contract().at(poolAddress);
    let result = await poolObj.withdraw(amount.toString()).send({feeLimit: 10000000});

    console.log("withdraw result: " + result);
    setHash(2, result);
}

async function getReward(poolAddress) {
    let poolObj = await tronWeb.contract().at(poolAddress);
    let result = await poolObj.getReward().send({feeLimit: 10000000});

    console.log("getReward result: " + result);
    setHash(3, result);
}


