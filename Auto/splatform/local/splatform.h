#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "EBM.h"
#include "ABS.h"
#include "CEM.h"
#include "../include/sensor.h"
#include "SecurityAttack.h"
#include "../models/PropCan_model.h"
#include "RestBus.h"
#include "EMU.h"
#include "../models/ChassisCan_model.h"
#include "../models/BodyCan_model.h"
#include "Cluster.h"
#include "Radio.h"
#include "powertrain.h"
#include "../include/powertrain.h"
$includes_end;

$module_begin("splatform");
SC_MODULE(splatform) {
public:
  typedef splatform SC_CURRENT_USER_MODULE;
  splatform(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("absfr"),
absfr(0)
$end
$init("absbr"),
absbr(0)
$end
$init("cluster0"),
cluster0(0)
$end
$init("chassiscan0"),
chassiscan0(0)
$end
$init("secattack0"),
secattack0(0)
$end
$init("brakesensor"),
brakesensor(0)
$end
$init("bodycan0"),
bodycan0(0)
$end
$init("cem0"),
cem0(0)
$end
$init("propcan0"),
propcan0(0)
$end
$init("ebm0"),
ebm0(0)
$end
$init("emu0"),
emu0(0)
$end
$init("accelsensor"),
accelsensor(0)
$end
$init("radio0"),
radio0(0)
$end
$init("absfl"),
absfl(0)
$end
$init("absbl"),
absbl(0)
$end
$init("restbus0"),
restbus0(0)
$end
$init("powertrain0"),
powertrain0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("absfr");
absfr = new ABS("absfr");
$end;
$create_component("absbr");
absbr = new ABS("absbr");
$end;
$create_component("cluster0");
cluster0 = new Cluster("cluster0");
$end;
$create_component("chassiscan0");
chassiscan0 = new ChassisCan_pvt("chassiscan0");
$end;
$create_component("secattack0");
secattack0 = new SecurityAttack("secattack0");
$end;
$create_component("brakesensor");
brakesensor = new sensor("brakesensor");
$end;
$create_component("bodycan0");
bodycan0 = new BodyCan_pvt("bodycan0");
$end;
$create_component("cem0");
cem0 = new CEM("cem0");
$end;
$create_component("propcan0");
propcan0 = new PropCan_pvt("propcan0");
$end;
$create_component("ebm0");
ebm0 = new EBM("ebm0");
$end;
$create_component("emu0");
emu0 = new EMU("emu0");
$end;
$create_component("accelsensor");
accelsensor = new sensor("accelsensor");
$end;
$create_component("radio0");
radio0 = new Radio("radio0");
$end;
$create_component("absfl");
absfl = new ABS("absfl");
$end;
$create_component("absbl");
absbl = new ABS("absbl");
$end;
$create_component("restbus0");
restbus0 = new RestBus("restbus0");
$end;
$create_component("powertrain0");
powertrain0 = new powertrain("powertrain0");
$end;
$bind("bodycan0->RX1","radio0->RX0");
vista_bind(bodycan0->RX1, radio0->RX0);
$end;
$bind("chassiscan0->RX0","cem0->RXchassis");
vista_bind(chassiscan0->RX0, cem0->RXchassis);
$end;
$bind("secattack0->TX0","bodycan0->TX0");
vista_bind(secattack0->TX0, bodycan0->TX0);
$end;
$bind("chassiscan0->RX6","ebm0->RX0");
vista_bind(chassiscan0->RX6, ebm0->RX0);
$end;
$bind("ebm0->TX0","chassiscan0->TX6");
vista_bind(ebm0->TX0, chassiscan0->TX6);
$end;
$bind("chassiscan0->RX5","absbr->RX0");
vista_bind(chassiscan0->RX5, absbr->RX0);
$end;
$bind("radio0->TX0","bodycan0->TX1");
vista_bind(radio0->TX0, bodycan0->TX1);
$end;
$bind("restbus0->TX0","chassiscan0->TX1");
vista_bind(restbus0->TX0, chassiscan0->TX1);
$end;
$bind("bodycan0->RX0","secattack0->RX0");
vista_bind(bodycan0->RX0, secattack0->RX0);
$end;
$bind("cem0->TXbody","bodycan0->TX2");
vista_bind(cem0->TXbody, bodycan0->TX2);
$end;
$bind("chassiscan0->RX3","absfr->RX0");
vista_bind(chassiscan0->RX3, absfr->RX0);
$end;
$bind("cem0->TXchassis","chassiscan0->TX0");
vista_bind(cem0->TXchassis, chassiscan0->TX0);
$end;
$bind("propcan0->RX1","cluster0->RX0");
vista_bind(propcan0->RX1, cluster0->RX0);
$end;
$bind("cluster0->TX0","propcan0->TX1");
vista_bind(cluster0->TX0, propcan0->TX1);
$end;
$bind("absfl->TX0","chassiscan0->TX2");
vista_bind(absfl->TX0, chassiscan0->TX2);
$end;
$bind("absbl->TX0","chassiscan0->TX4");
vista_bind(absbl->TX0, chassiscan0->TX4);
$end;
$bind("propcan0->RX2","emu0->RX0");
vista_bind(propcan0->RX2, emu0->RX0);
$end;
$bind("propcan0->RX0","cem0->RXprop");
vista_bind(propcan0->RX0, cem0->RXprop);
$end;
$bind("absfr->TX0","chassiscan0->TX3");
vista_bind(absfr->TX0, chassiscan0->TX3);
$end;
$bind("absbr->TX0","chassiscan0->TX5");
vista_bind(absbr->TX0, chassiscan0->TX5);
$end;
$bind("chassiscan0->RX1","restbus0->RX0");
vista_bind(chassiscan0->RX1, restbus0->RX0);
$end;
$bind("chassiscan0->RX4","absbl->RX0");
vista_bind(chassiscan0->RX4, absbl->RX0);
$end;
$bind("cem0->TXprop","propcan0->TX0");
vista_bind(cem0->TXprop, propcan0->TX0);
$end;
$bind("emu0->TX0","propcan0->TX2");
vista_bind(emu0->TX0, propcan0->TX2);
$end;
$bind("chassiscan0->RX2","absfl->RX0");
vista_bind(chassiscan0->RX2, absfl->RX0);
$end;
$bind("bodycan0->RX2","cem0->RXbody");
vista_bind(bodycan0->RX2, cem0->RXbody);
$end;
$bind("emu0->s","accelsensor->p");
vista_bind(emu0->s, accelsensor->p);
$end;
$bind("ebm0->s","brakesensor->p");
vista_bind(ebm0->s, brakesensor->p);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
    // User connections
    emu0->e(powertrain0->eng);
    ebm0->b(powertrain0->brk);
    absfl->s(powertrain0->wfl);
    absfr->s(powertrain0->wfr);
    absbl->s(powertrain0->wbl);
    absbr->s(powertrain0->wbr);
  }
  ~splatform() {
    $destructor_begin;
$destruct_component("absfr");
delete absfr; absfr = 0;
$end;
$destruct_component("absbr");
delete absbr; absbr = 0;
$end;
$destruct_component("cluster0");
delete cluster0; cluster0 = 0;
$end;
$destruct_component("chassiscan0");
delete chassiscan0; chassiscan0 = 0;
$end;
$destruct_component("secattack0");
delete secattack0; secattack0 = 0;
$end;
$destruct_component("brakesensor");
delete brakesensor; brakesensor = 0;
$end;
$destruct_component("bodycan0");
delete bodycan0; bodycan0 = 0;
$end;
$destruct_component("cem0");
delete cem0; cem0 = 0;
$end;
$destruct_component("propcan0");
delete propcan0; propcan0 = 0;
$end;
$destruct_component("ebm0");
delete ebm0; ebm0 = 0;
$end;
$destruct_component("emu0");
delete emu0; emu0 = 0;
$end;
$destruct_component("accelsensor");
delete accelsensor; accelsensor = 0;
$end;
$destruct_component("radio0");
delete radio0; radio0 = 0;
$end;
$destruct_component("absfl");
delete absfl; absfl = 0;
$end;
$destruct_component("absbl");
delete absbl; absbl = 0;
$end;
$destruct_component("restbus0");
delete restbus0; restbus0 = 0;
$end;
$destruct_component("powertrain0");
delete powertrain0; powertrain0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("absfr");
ABS *absfr;
$end;
$component("absbr");
ABS *absbr;
$end;
$component("cluster0");
Cluster *cluster0;
$end;
$component("chassiscan0");
ChassisCan_pvt *chassiscan0;
$end;
$component("secattack0");
SecurityAttack *secattack0;
$end;
$component("brakesensor");
sensor *brakesensor;
$end;
$component("bodycan0");
BodyCan_pvt *bodycan0;
$end;
$component("cem0");
CEM *cem0;
$end;
$component("propcan0");
PropCan_pvt *propcan0;
$end;
$component("ebm0");
EBM *ebm0;
$end;
$component("emu0");
EMU *emu0;
$end;
$component("accelsensor");
sensor *accelsensor;
$end;
$component("radio0");
Radio *radio0;
$end;
$component("absfl");
ABS *absfl;
$end;
$component("absbl");
ABS *absbl;
$end;
$component("restbus0");
RestBus *restbus0;
$end;
$component("powertrain0");
powertrain *powertrain0;
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