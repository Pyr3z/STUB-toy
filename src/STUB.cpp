/*! ***************************************************************************
\ll ** -- FILE DETAILS ----------------------------------------------------- **
\ll ***************************************************************************
    \file     STUB.cpp
    \project  SANITIES
    \module   STUB
    \author   [Levi Perez](https://leviperez.dev)  \n
    \email    <levi@leviperez.dev>                 \n
    \discord  [Leviathan#2318](https://discordapp.com/channels/@me)
    \copyleft @ref LICENSE (<https://unlicense.org>)
\ll ***************************************************************************
\ll ** -- FILE USAGE ------------------------------------------------------- **
\ll ***************************************************************************
    \brief    --
    \details  --
\ll ***************************************************************************
\ll ** -- DEVELOPMENT HISTORY & ROADMAP ------------------------------------ **
\ll ***************************************************************************
    \version  0.1.0

    \created  2020-02-04 (15:07:09)
    \updated  2020-02-04 (15:07:10) : LINK-TO-CHANGELOG

    \todo     Un-STUB-ify this file.
******************************************************************************/

#if !defined(__cplusplus) || __cplusplus < 201103L
  #error "Please compile with C++11 or newer."
#endif

// #pragma GCC diagnostic push

#include <iostream> //!< std::cout



int main(int argc, const char* const argv[])
{
  while (argc --> 0) std::cout << argv[argc] << '\n';

  std::cout.flush();

  return 0;
}

// #pragma GCC diagnostic pop
