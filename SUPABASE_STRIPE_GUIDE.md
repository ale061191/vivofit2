# Guía de Integración Backend (Supabase + Stripe)

Para que los pagos funcionen, necesitas desplegar una "Edge Function" en Supabase. Esta función actúa como intermediario seguro para crear las intenciones de pago en Stripe.

## Pasos Previos

1.  Tener cuenta en [Stripe](https://stripe.com).
2.  Tener el proyecto en [Supabase](https://supabase.com).
3.  Instalar Supabase CLI en tu computadora (si vas a desplegar desde local).

## 1. Configurar Variables de Entorno en Supabase

Ve a tu Dashboard de Supabase -> Settings -> Edge Functions y agrega tu clave secreta de Stripe:

-   Nombre: `STRIPE_SECRET_KEY`
-   Valor: `sk_test_...` (Tu clave secreta de Stripe)

## 2. Código de la Edge Function

Crea una función llamada `payment-sheet`.

**Archivo: `supabase/functions/payment-sheet/index.ts`**

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') as string, {
  apiVersion: '2022-11-15',
  httpClient: Stripe.createFetchHttpClient(),
})

serve(async (req) => {
  try {
    // 1. Obtener datos del request
    const { amount, currency } = await req.json()

    // 2. Crear o buscar un cliente en Stripe (Simplificado: crea uno nuevo siempre)
    // En producción, deberías guardar el stripe_customer_id en tu tabla de usuarios de Supabase
    const customer = await stripe.customers.create()

    // 3. Crear una Ephemeral Key (necesaria para el Payment Sheet)
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: '2022-11-15' }
    )

    // 4. Crear el PaymentIntent (La intención de cobro)
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // En centavos (ej: 2499 para $24.99)
      currency: currency,
      customer: customer.id,
      automatic_payment_methods: {
        enabled: true,
      },
    })

    // 5. Retornar las 3 claves necesarias a la App Flutter
    return new Response(
      JSON.stringify({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
      }),
      {
        headers: { "Content-Type": "application/json" },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 400,
    })
  }
})
```

## 3. Desplegar la función

Ejecuta en tu terminal:

```bash
supabase functions deploy payment-sheet
```

¡Listo! Ahora tu app Flutter podrá comunicarse con esta función para iniciar pagos seguros.
