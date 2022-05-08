import React from 'react';
import {View, NativeModules, NativeEventEmitter} from 'react-native';
import {useEffect, useState} from 'react';

const InstantTransmission = NativeModules.InstantTransmissionModule;
const InstantTransmissionEventEmitter = new NativeEventEmitter(
  NativeModules.InstantTransmissionModule,
);

const App = () => {
  const [recordedCursorPositions, setRecordedCursorPositions] = useState([]);

  useEffect(() => {
    let listenerOne = InstantTransmissionEventEmitter.addListener(
      'recordCursor',
      event => {
        if (recordedCursorPositions.length < 3) {
          setRecordedCursorPositions([
            ...recordedCursorPositions,
            {id: recordedCursorPositions.length, ...event},
          ]);
        }
      },
    );

    let listeneTwo = InstantTransmissionEventEmitter.addListener(
      'moveCursor',
      event => {
        if (recordedCursorPositions[event.index]) {
          const {x, y} = recordedCursorPositions[event.index];
          InstantTransmission.moveCursorTo(x, y);
        }
      },
    );

    return () => {
      listeneTwo.remove();
      listenerOne.remove();
    };
  }, [recordedCursorPositions]);

  console.log('cursors ', recordedCursorPositions);

  return <View style={{width: 100, height: 200, backgroundColor: 'pink'}} />;
};

export default App;
