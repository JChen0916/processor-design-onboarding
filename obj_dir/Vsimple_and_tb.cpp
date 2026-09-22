// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vsimple_and_tb__pch.h"

//============================================================
// Constructors

Vsimple_and_tb::Vsimple_and_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vsimple_and_tb__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vsimple_and_tb::Vsimple_and_tb(const char* _vcname__)
    : Vsimple_and_tb(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vsimple_and_tb::~Vsimple_and_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vsimple_and_tb___024root___eval_debug_assertions(Vsimple_and_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vsimple_and_tb___024root___eval_static(Vsimple_and_tb___024root* vlSelf);
void Vsimple_and_tb___024root___eval_initial(Vsimple_and_tb___024root* vlSelf);
void Vsimple_and_tb___024root___eval_settle(Vsimple_and_tb___024root* vlSelf);
void Vsimple_and_tb___024root___eval(Vsimple_and_tb___024root* vlSelf);

void Vsimple_and_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vsimple_and_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vsimple_and_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vsimple_and_tb___024root___eval_static(&(vlSymsp->TOP));
        Vsimple_and_tb___024root___eval_initial(&(vlSymsp->TOP));
        Vsimple_and_tb___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vsimple_and_tb___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vsimple_and_tb::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vsimple_and_tb::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vsimple_and_tb::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vsimple_and_tb___024root___eval_final(Vsimple_and_tb___024root* vlSelf);

VL_ATTR_COLD void Vsimple_and_tb::final() {
    Vsimple_and_tb___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vsimple_and_tb::hierName() const { return vlSymsp->name(); }
const char* Vsimple_and_tb::modelName() const { return "Vsimple_and_tb"; }
unsigned Vsimple_and_tb::threads() const { return 1; }
void Vsimple_and_tb::prepareClone() const { contextp()->prepareClone(); }
void Vsimple_and_tb::atClone() const {
    contextp()->threadPoolpOnClone();
}
