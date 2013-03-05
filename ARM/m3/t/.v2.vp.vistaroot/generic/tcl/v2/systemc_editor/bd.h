#ifndef __bd_h__
#define __bd_h__

   $includes_begin   ;
#include <systemc>
      $includes_end ;


6ISTA_MODULE_BEGIN(     "\"b\\(d\\\" "   );
$module_begin(     "a"   );
template<class DataType, int size>
class bd: public sc_module {
public:
  bd(bool isLeaf, char *cpu_model)
    : isLeaf(isLeaf) {
    
    if(isLeaf) {
      registerLeaf<DataType>(size);
      {    }
    $elaboration_begin;
      
    $create_component("my_cpu");
    my_cpu = new CPU("my_cpu");
    my_cpu = myClass::createCPU("my_cpu", 5, 6, 7);
    $end;
    
    $create_component("CPU");
    this->cpu = CPURegistry::createCPU(cpu_model);
    cpu->setIsLeaf(isLeaf);
    cpu->debug_on();
    
    $end;

#if 0 
    $create_component("L1cache");
    l1 = new L1Cache();
    l1->setCacheSize(getParameter("L1_CACHE_SIZE"));
    /* you can write here whatever you want.*/
    $end;
#endif

    $bind("L1cache->slave_port"       , "CPU->cache_port");
    l1->slave_port(cpu->/* and here */ cache_port);
    $bind_end;
    
    $bind("interrupt_port", "CPU->interrupt_port");    interrupt_port(CPU->interrupt_port);    $bind_end;    
aaa bbb ccc $elaboration_end;
  }

  ~bd() {
  }

public:
  $ports_begin;
  
  $field("interrupt_port");  
  sc_port<sc_interrupt_if> interrupt_port;
  $end;

  $field("interrupt_port");  
  sc_port<sc_interrupt_if> interrupt_port;
  $end;

  $field("interrupt_port");  
  sc_port<sc_interrupt_if> interrupt_port;
  $end;
  
  $ports_end;
  
private:
  $fields_begin;

  $field("my_cpu");
  CPU *my_cpu;  
  $end;

  $field("CPU") CPU *cpu; $end;  $field("L1cache") L1CacheReference l1; $end;
  $fields_end;
};
$module_end;

#endif
