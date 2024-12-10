import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const GreetingModule = buildModule("GreetingModule", (m) => {
    const greetings = m.contract("Greeting", [], {});
    return { greetings };
});

export default GreetingModule;