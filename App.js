import React from 'react';
import {View, NativeModules} from 'react-native';

import {useEffect} from 'react';

const App = () => {
  useEffect(() => {
    // NativeModules.InstantTransmissionModule.getName;
    console.log('wddefe', NativeModules.InstantTransmissionModule.getName());
  }, []);

  return <View style={{width: 100, height: 200, backgroundColor: 'pink'}} />;
};

export default App;
