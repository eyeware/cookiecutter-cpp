/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

 #include "eyeware/sdk/common.h"

 namespace eyeware {
 namespace sdk {

   CommonType create_common_type(int value, float precise_value) {
      CommonType result;

      result.value = value;
      result.precise_value = precise_value;

      return result;
   }

 } // namespace sdk
 } // namespace eyeware
