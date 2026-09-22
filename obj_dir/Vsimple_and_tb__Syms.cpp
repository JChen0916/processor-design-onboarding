// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vsimple_and_tb__pch.h"
#include "Vsimple_and_tb.h"
#include "Vsimple_and_tb___024root.h"

// FUNCTIONS
Vsimple_and_tb__Syms::~Vsimple_and_tb__Syms()
{
}

Vsimple_and_tb__Syms::Vsimple_and_tb__Syms(VerilatedContext* contextp, const char* namep, Vsimple_and_tb* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(18);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
    __Vscope_simple_and_tb.configure(this, name(), "simple_and_tb", "simple_and_tb", "<null>", -12, VerilatedScope::SCOPE_OTHER);
}
