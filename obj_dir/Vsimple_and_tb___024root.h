// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vsimple_and_tb.h for the primary calling header

#ifndef VERILATED_VSIMPLE_AND_TB___024ROOT_H_
#define VERILATED_VSIMPLE_AND_TB___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vsimple_and_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vsimple_and_tb___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ simple_and_tb__DOT__a;
    CData/*0:0*/ simple_and_tb__DOT__b;
    CData/*0:0*/ simple_and_tb__DOT__y;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vsimple_and_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vsimple_and_tb___024root(Vsimple_and_tb__Syms* symsp, const char* v__name);
    ~Vsimple_and_tb___024root();
    VL_UNCOPYABLE(Vsimple_and_tb___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
