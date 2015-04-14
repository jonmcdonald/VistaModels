#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "Cluster.h"
#include "Accelerator.h"
#include "Radio.h"
#include "SecurityAttack.h"
#include "ABS.h"
#include "EMU.h"
#include "RestBus.h"
#include "../models/canls_model.h"
#include "../models/canhs_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cluster0"),
cluster0(0)
$end
$init("radio0"),
radio0(0)
$end
$init("accelerator0"),
accelerator0(0)
$end
$init("lscan0"),
lscan0(0)
$end
$init("hscan0"),
hscan0(0)
$end
$init("securityattack0"),
securityattack0(0)
$end
$init("emu0"),
emu0(0)
$end
$init("restbus0"),
restbus0(0)
$end
$init("abs0"),
abs0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cluster0");
cluster0 = new Cluster("cluster0");
$end;
$create_component("radio0");
radio0 = new Radio("radio0");
$end;
$create_component("accelerator0");
accelerator0 = new Accelerator("accelerator0");
$end;
$create_component("lscan0");
lscan0 = new canls_pvt("lscan0");
$end;
$create_component("hscan0");
hscan0 = new canhs_pvt("hscan0");
$end;
$create_component("securityattack0");
securityattack0 = new SecurityAttack("securityattack0");
$end;
$create_component("emu0");
emu0 = new EMU("emu0");
$end;
$create_component("restbus0");
restbus0 = new RestBus("restbus0");
$end;
$create_component("abs0");
abs0 = new ABS("abs0");
$end;
$bind("lscan0->c_rx","cluster0->RXLS");
vista_bind(lscan0->c_rx, cluster0->RXLS);
$end;
$bind("cluster0->TXLS","lscan0->c_tx");
vista_bind(cluster0->TXLS, lscan0->c_tx);
$end;
$bind("accelerator0->TX0","lscan0->ap_tx");
vista_bind(accelerator0->TX0, lscan0->ap_tx);
$end;
$bind("lscan0->ap_rx","accelerator0->RX0");
vista_bind(lscan0->ap_rx, accelerator0->RX0);
$end;
$bind("hscan0->c_rx","cluster0->RXHS");
vista_bind(hscan0->c_rx, cluster0->RXHS);
$end;
$bind("emu0->TX0","hscan0->emu_tx");
vista_bind(emu0->TX0, hscan0->emu_tx);
$end;
$bind("hscan0->rbl_rx","restbus0->RX0");
vista_bind(hscan0->rbl_rx, restbus0->RX0);
$end;
$bind("abs0->TX0","hscan0->abs_tx");
vista_bind(abs0->TX0, hscan0->abs_tx);
$end;
$bind("hscan0->emu_rx","emu0->RX0");
vista_bind(hscan0->emu_rx, emu0->RX0);
$end;
$bind("hscan0->abs_rx","abs0->RX0");
vista_bind(hscan0->abs_rx, abs0->RX0);
$end;
$bind("restbus0->TX0","hscan0->rbl_tx");
vista_bind(restbus0->TX0, hscan0->rbl_tx);
$end;
$bind("cluster0->TXHS","hscan0->c_tx");
vista_bind(cluster0->TXHS, hscan0->c_tx);
$end;
$bind("radio0->TX0","lscan0->r_tx");
vista_bind(radio0->TX0, lscan0->r_tx);
$end;
$bind("lscan0->r_rx","radio0->RX0");
vista_bind(lscan0->r_rx, radio0->RX0);
$end;
$bind("hscan0->sa_rx","securityattack0->RX0");
vista_bind(hscan0->sa_rx, securityattack0->RX0);
$end;
$bind("securityattack0->TX0","hscan0->sa_tx");
vista_bind(securityattack0->TX0, hscan0->sa_tx);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("cluster0");
delete cluster0; cluster0 = 0;
$end;
$destruct_component("radio0");
delete radio0; radio0 = 0;
$end;
$destruct_component("accelerator0");
delete accelerator0; accelerator0 = 0;
$end;
$destruct_component("lscan0");
delete lscan0; lscan0 = 0;
$end;
$destruct_component("hscan0");
delete hscan0; hscan0 = 0;
$end;
$destruct_component("securityattack0");
delete securityattack0; securityattack0 = 0;
$end;
$destruct_component("emu0");
delete emu0; emu0 = 0;
$end;
$destruct_component("restbus0");
delete restbus0; restbus0 = 0;
$end;
$destruct_component("abs0");
delete abs0; abs0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cluster0");
Cluster *cluster0;
$end;
$component("radio0");
Radio *radio0;
$end;
$component("accelerator0");
Accelerator *accelerator0;
$end;
$component("lscan0");
canls_pvt *lscan0;
$end;
$component("hscan0");
canhs_pvt *hscan0;
$end;
$component("securityattack0");
SecurityAttack *securityattack0;
$end;
$component("emu0");
EMU *emu0;
$end;
$component("restbus0");
RestBus *restbus0;
$end;
$component("abs0");
ABS *abs0;
$end;
  $fields_end;
  $vlnv_decl_begin;
public:
const char* m_library;
const char* m_vendor;
const char* m_version;
  $vlnv_decl_end;
};
$module_end;