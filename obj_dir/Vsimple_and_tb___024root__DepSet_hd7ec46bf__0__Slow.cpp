// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsimple_and_tb.h for the primary calling header

#include "Vsimple_and_tb__pch.h"
#include "Vsimple_and_tb__Syms.h"
#include "Vsimple_and_tb___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsimple_and_tb___024root___dump_triggers__stl(Vsimple_and_tb___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vsimple_and_tb___024root___eval_triggers__stl(Vsimple_and_tb___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vsimple_and_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_and_tb___024root___eval_triggers__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered.set(0U, (IData)(vlSelfRef.__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsimple_and_tb___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
