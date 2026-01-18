import { ConfigService } from '@nestjs/config';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { AggregatedConfig } from 'src/config/config.type';
// Using require to import package.json because using import keyword
// requires additional configuration in tsconfig.json (resolveJsonModule: true)
// and this messes up dist folder structure.
/* eslint-disable @typescript-eslint/no-var-requires */
const packageJson = require('../../../package.json');

// We have ResponseTransformerInterceptor which wraps every response data
// with ApiResponse generic. Currently all the endpoints define only the
// response data part, meaning ApiResponse is ignored, so we need
// to define full ApiResponse in Swagger.
const wrapResponseWithApiResponseWrapper = (document: OpenAPIObject) => {
  Object.values(document.paths).forEach((pathItem) => {
    Object.values(pathItem).forEach((operation: any) => {
      const responses = operation.responses;

      if (!responses) {
        return;
      }

      Object.keys(responses).forEach((statusCode) => {
        if (statusCode === '204') {
          return;
        }

        if (statusCode.startsWith('4') || statusCode.startsWith('5')) {
          return;
        }

        const response = responses[statusCode];
        const jsonContent = response.content?.['application/json'];

        if (jsonContent && jsonContent.schema) {
          const originalSchema = jsonContent.schema;

          jsonContent.schema = {
            type: 'object',
            properties: {
              data: originalSchema,
              // For 2xx response error property is null
              error: { type: 'object', nullable: true, example: null },
            },
            required: ['data', 'error'],
          };
        }
      });
    });
  });
};

const setupApiDocs = (
  app: NestExpressApplication,
  configService: ConfigService<AggregatedConfig>,
) => {
  const apiPrefix = configService.getOrThrow('app.apiPrefix', { infer: true });
  const options = new DocumentBuilder()
    .setTitle('Taskie API')
    .setDescription('API docs')
    .setVersion(packageJson.version)
    .addBearerAuth()
    .addGlobalParameters(
      {
        in: 'header',
        required: false,
        name: 'x-device-model',
        schema: {
          example: 'SM-S911B',
        },
      },
      {
        in: 'header',
        required: false,
        name: 'x-os-version',
        schema: {
          example: '14',
        },
      },
      {
        in: 'header',
        required: false,
        name: 'x-app-version',
        schema: {
          example: '1.0.0',
        },
      },
    )
    .build();

  const document = SwaggerModule.createDocument(app, options);
  wrapResponseWithApiResponseWrapper(document);
  SwaggerModule.setup(`${apiPrefix}/docs`, app, document);
};

export default setupApiDocs;
