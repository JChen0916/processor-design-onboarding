// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsimple_and_tb.h for the primary calling header

#include "Vsimple_and_tb__pch.h"
#include "Vsimple_and_tb__Syms.h"
#include "Vsimple_and_tb___024root.h"

void Vsimple_and_tb___024root___ctor_var_reset(Vsimple_and_tb___024root* vlSelf);

Vsimple_and_tb___024root::Vsimple_and_tb___024root(Vsimple_and_tb__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vsimple_and_tb___024root___ctor_var_reset(this);
}

void Vsimple_and_tb___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vsimple_and_tb___024root::~Vsimple_and_tb___024root() {
}
