
MEMORY
{
  icc (rw)  : ORIGIN = 0x1f000100, LENGTH = 0x100
  icd (rw)  : ORIGIN = 0x1f001000, LENGTH = 4K      
}

SECTIONS
{
  .icc (INFO) : ALIGN (4)
  {
     *(.icc)
  } >icc

  .icd (INFO) : ALIGN (4)
  {
    *(.icd)
  } >icd

}
