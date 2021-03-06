Require Import Coq.ZArith.BinInt.
Require Import bbv.WordScope.
Require Import riscv.RiscvBitWidths.
Require Import riscv.Decode.
Require Import riscv.Memory.
Require Import riscv.Utility.


Class RegisterFile{RF R V: Type} := mkRegisterFile {
  getReg: RF -> R -> V;
  setReg: RF -> R -> V -> RF;
  initialRegs: RF;
}.

Arguments RegisterFile: clear implicits.

Section Riscv.

  Context {B: RiscvBitWidths}.
  Context {Mem: Set}.
  Context {MemIsMem: Memory Mem wXLEN}.
  Context {RF: Type}.
  Context {RFI: RegisterFile RF Register (word wXLEN)}.
  
  Record RiscvMachineCore := mkRiscvMachineCore {
    registers: RF;
    pc: word wXLEN;
    nextPC: word wXLEN;
    exceptionHandlerAddr: MachineInt;
  }.

  Record RiscvMachine := mkRiscvMachine {
    core: RiscvMachineCore;
    machineMem: Mem;
  }.

  Definition with_registers r ma :=
    mkRiscvMachine (mkRiscvMachineCore
        r ma.(core).(pc) ma.(core).(nextPC) ma.(core).(exceptionHandlerAddr))
        ma.(machineMem).
  Definition with_pc p ma :=
    mkRiscvMachine (mkRiscvMachineCore
        ma.(core).(registers) p ma.(core).(nextPC) ma.(core).(exceptionHandlerAddr))
        ma.(machineMem).
  Definition with_nextPC npc ma :=
    mkRiscvMachine (mkRiscvMachineCore
        ma.(core).(registers) ma.(core).(pc) npc ma.(core).(exceptionHandlerAddr))
        ma.(machineMem).
  Definition with_exceptionHandlerAddr eh ma :=
    mkRiscvMachine (mkRiscvMachineCore
        ma.(core).(registers) ma.(core).(pc) ma.(core).(nextPC) eh)
        ma.(machineMem).
  Definition with_machineMem m ma :=
    mkRiscvMachine ma.(core) m.

End Riscv.
