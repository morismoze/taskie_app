// Abstract class is used just for sake of simplicity
// if in the future this class will have shared
// methods with defined bodies. And also for the
// fact that it is easier to DI abstract class
// rather than an interface (interface needs to
// provided and injected via DI token since it
// doesn't exist in the runtime, class does).

import { LoggerService } from '@nestjs/common';

// This implements NestJs's LoggerService so we can
// make it a custom logger which NestJs can use instead
// of its own Logger class. The connection is done in
// the bootstrap() function.
// Because we want to use Nest's logger behind the hood,
// which calls log, warn and error methods with positional
// args, and not an object, we can't make arggument of these
// methods an object.
export abstract class AppLogger implements LoggerService {
  abstract log(message: any, context?: string): any;
  abstract warn(message: any, context?: string): any;
  abstract error(message: any, stackTrace?: string, context?: string): any;
}
