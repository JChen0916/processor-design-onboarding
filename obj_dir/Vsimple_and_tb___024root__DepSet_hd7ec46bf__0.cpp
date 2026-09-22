// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsimple_and_tb.h for the primary calling header

#include "Vsimple_and_tb__pch.h"
#include "Vsimple_and_tb__Syms.h"
#include "Vsimple_and_tb___024root.h"

VL_INLINE_OPT VlCoroutine Vsimple_and_tb___024root___eval_initial__TOP__Vtiming__0(Vsimple_and_tb___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vsimple_and_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_and_tb___024root___eval_initial__TOP__Vtiming__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.simple_and_tb__DOT__a = 0U;
    vlSelfRef.simple_and_tb__DOT__b = 0U;
    co_await vlSelfRef.__VdlySched.delay(1ULL, nullptr, 
                                         "lab_1/tb/simple_and_tb.sv", 
                                         14);
    if (VL_UNLIKELY(vlSelfRef.simple_and_tb__DOT__y)) {
        VL_WRITEF_NX("[%0t] %%Fatal: simple_and_tb.sv:15: Assertion failed in %Nsimple_and_tb\n",0,
                     64,VL_TIME_UNITED_Q(1),-12,vlSymsp->name());
        VL_STOP_MT("lab_1/tb/simple_and_tb.sv", 15, "", false);
    }
    vlSelfRef.simple_and_tb__DOT__a = 0U;
    vlSelfRef.simple_and_tb__DOT__b = 1U;
    co_await vlSelfRef.__VdlySched.delay(1ULL, nullptr, 
                                         "lab_1/tb/simple_and_tb.sv", 
                                         17);
    if (VL_UNLIKELY(vlSelfRef.simple_and_tb__DOT__y)) {
        VL_WRITEF_NX("[%0t] %%Fatal: simple_and_tb.sv:18: Assertion failed in %Nsimple_and_tb\n",0,
                     64,VL_TIME_UNITED_Q(1),-12,vlSymsp->name());
        VL_STOP_MT("lab_1/tb/simple_and_tb.sv", 18, "", false);
    }
    vlSelfRef.simple_and_tb__DOT__a = 1U;
    vlSelfRef.simple_and_tb__DOT__b = 0U;
    co_await vlSelfRef.__VdlySched.delay(1ULL, nullptr, 
                                         "lab_1/tb/simple_and_tb.sv", 
                                         20);
    if (VL_UNLIKELY(vlSelfRef.simple_and_tb__DOT__y)) {
        VL_WRITEF_NX("[%0t] %%Fatal: simple_and_tb.sv:21: Assertion failed in %Nsimple_and_tb\n",0,
                     64,VL_TIME_UNITED_Q(1),-12,vlSymsp->name());
        VL_STOP_MT("lab_1/tb/simple_and_tb.sv", 21, "", false);
    }
    vlSelfRef.simple_and_tb__DOT__a = 1U;
    vlSelfRef.simple_and_tb__DOT__b = 1U;
    co_await vlSelfRef.__VdlySched.delay(1ULL, nullptr, 
                                         "lab_1/tb/simple_and_tb.sv", 
                                         23);
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.simple_and_tb__DOT__y))))) {
        VL_WRITEF_NX("[%0t] %%Fatal: simple_and_tb.sv:24: Assertion failed in %Nsimple_and_tb\n",0,
                     64,VL_TIME_UNITED_Q(1),-12,vlSymsp->name());
        VL_STOP_MT("lab_1/tb/simple_and_tb.sv", 24, "", false);
    }
    VL_WRITEF_NX("All tests passed!\n",0);
    VL_FINISH_MT("lab_1/tb/simple_and_tb.sv", 27, "");
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsimple_and_tb___024root___dump_triggers__act(Vsimple_and_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vsimple_and_tb___024root___eval_triggers__act(Vsimple_and_tb___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vsimple_and_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_and_tb___024root___eval_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.set(0U, vlSelfRef.__VdlySched.awaitingCurrentTime());
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsimple_and_tb___024root___dump_triggers__act(vlSelf);
    }
#endif
}
