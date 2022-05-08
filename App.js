import React from 'react';
import {View, NativeModules, NativeEventEmitter} from 'react-native';

import {useEffect, useState} from 'react';

const App = () => {
  const [recordedCursorPositions, setRecordedCursorPositions] = useState([]);

  useEffect(() => {
    console.log(
      'modulecall',
      NativeModules.InstantTransmissionModule.getName(),
    );

    const eventEmitter = new NativeEventEmitter(
      NativeModules.InstantTransmissionModule,
    );

    eventEmitter.addListener('recordCursor', data => console.log(data));
    eventEmitter.addListener('moveCursor', data => console.log(data));
  }, []);

  return <View style={{width: 100, height: 200, backgroundColor: 'pink'}} />;
};

export default App;
