// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VSIMPLE_AND_TB__SYMS_H_
#define VERILATED_VSIMPLE_AND_TB__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vsimple_and_tb.h"

// INCLUDE MODULE CLASSES
#include "Vsimple_and_tb___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vsimple_and_tb__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vsimple_and_tb* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vsimple_and_tb___024root       TOP;

    // SCOPE NAMES
    VerilatedScope __Vscope_simple_and_tb;

    // CONSTRUCTORS
    Vsimple_and_tb__Syms(VerilatedContext* contextp, const char* namep, Vsimple_and_tb* modelp);
    ~Vsimple_and_tb__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
