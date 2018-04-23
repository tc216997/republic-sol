const DarkNodeRegistry = artifacts.require("DarkNodeRegistry");
const RepublicToken = artifacts.require("RepublicToken");
const Hyperdrive = artifacts.require("Hyperdrive");

const chai = require("chai");
chai.use(require("chai-as-promised"));
chai.should();

contract("Hyperdrive", function (accounts) {

    let ren, dnr, hyperdrive;

    before(async function () {
        ren = await RepublicToken.new();
        dnr = await DarkNodeRegistry.new(ren.address, 100, 72, 0);
        hyperdrive = await Hyperdrive.new(dnr.address);

        for (i = 1; i < accounts.length; i++) {
            await ren.transfer(accounts[i], 100);
        }

        for (i = 0; i < accounts.length; i++) {
            uid = (i + 1).toString();
            await ren.approve(dnr.address, 100, {from: accounts[i]});
            await dnr.register(accounts[i], uid, 100, {from: accounts[i]});
        }

        await dnr.epoch();
        for (i = 0; i < accounts.length; i++) {
            assert.equal((await dnr.isRegistered(accounts[i])), true);
        }

    });

    it("can send tx which has no conflicts", async () => {
        await hyperdrive.sendTx(["0", "1", "2"], {from: accounts[0]});
        await hyperdrive.sendTx(["3", "4", "5"], {from: accounts[1]});
        await hyperdrive.sendTx(["6", "7", "8"], {from: accounts[2]});
    });

    it("will be rejected if sending tx which has conflicts", async () => {
        await hyperdrive.sendTx(["0", "1", "2"], {from: accounts[3]}).should.be.rejectedWith();
        await hyperdrive.sendTx(["3", "4", "10"], {from: accounts[3]}).should.be.rejectedWith();
        await hyperdrive.sendTx(["8", "9", "10"], {from: accounts[3]}).should.be.rejectedWith();
    });
});